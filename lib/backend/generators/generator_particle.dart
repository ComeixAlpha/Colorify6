import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:colorify/backend/abstracts/rgbmapping.dart';
import 'package:colorify/backend/extensions/on_dateTime.dart';
import 'package:colorify/backend/extensions/on_iterable.dart';
import 'package:colorify/backend/extensions/on_string.dart';
import 'package:colorify/backend/generators/generator_package.dart';
import 'package:colorify/backend/providers/particle.prov.dart';
import 'package:colorify/backend/utils/minecraft/functionmaker.dart';
import 'package:colorify/backend/utils/common/matcher.dart';
import 'package:colorify/backend/utils/common/math.dart';
import 'package:colorify/backend/utils/algo/rotator.dart';
import 'package:colorify/frontend/scaffold/bottombar.dart';
import 'package:image/image.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class GenParticleArguments {
  Image? image;
  double? samp;
  double? heig;
  double? rx;
  double? ry;
  double? rz;
  String? pkName;
  String? pkAuth;
  String? pkDesc;
  final int plane;
  final GenerateType type;
  final GenerateMode mode;
  final Directory outDir;
  final List<RGBMapping> mappings;

  GenParticleArguments({
    required this.image,
    required this.samp,
    required this.heig,
    required this.rx,
    required this.ry,
    required this.rz,
    required this.pkName,
    required this.pkAuth,
    required this.pkDesc,
    required this.plane,
    required this.type,
    required this.mode,
    required this.outDir,
    required this.mappings,
  });
}

class ParticlePoint {
  double x;
  double y;
  double z;

  String pid;

  int? r;
  int? g;
  int? b;

  ParticlePoint({
    required this.x,
    required this.y,
    required this.z,
    required this.pid,
    this.r,
    this.g,
    this.b,
  });
}

void Function(SendPort) pArgClosure(GenParticleArguments args) {
  return (SendPort sendPort) async {
    final ReceivePort receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);

    final plan = args.plane;

    /// Image null error
    final image = args.image;
    if (image == null) {
      sendPort.send(-1.0);
      return;
    }

    final width = image.width;
    final height = image.height;

    /// Auto sampling
    if (args.samp == null) {
      final areaSize = width * height;
      if (areaSize > 20000) {
        args.samp = sqrt(20000 / areaSize);
      } else {
        args.samp = 1;
      }
    }

    /// Matches
    final res = match(
      image,
      args.samp!,
      (x, y, v) {
        if (args.mode == GenerateMode.dust) {
          return MatchResult(x: x, y: y, id: [v.r, v.g, v.b].join(','));
        }
        num mindis = double.infinity;
        String latest = '';
        for (RGBMapping mapping in args.mappings) {
          final dis = sqrt([mapping.r - v.r, mapping.g - v.g, mapping.b - v.b].map((e) => pow(e, 2).toDouble()).sum());
          if (dis > 30) {
            continue;
          }
          if (dis < mindis) {
            mindis = dis;
            latest = mapping.id;
          }
        }
        if (latest.isEmpty) {
          return null;
        }
        return MatchResult(
          x: x,
          y: y,
          id: latest,
        );
      },
    );

    /// Rotate
    bool needRot = [args.rx, args.ry, args.rz].any((e) => e != null);
    if (needRot) {
      args.rx ??= 0;
      args.ry ??= 0;
      args.rz ??= 0;
    }

    /// No matches
    if (res.isEmpty) {
      sendPort.send(1.0);
      return;
    }

    Directory zpDir;
    Directory bpOutDir;
    Directory rpOutDir;
    Directory fnOutDir;

    /// Pack
    bool isMatchMode = args.mode == GenerateMode.match;
    bool needPack = [args.pkName, args.pkAuth, args.pkDesc].any((e) => e!.isNotEmpty);
    if (!isMatchMode) {
      needPack = true;
    }
    if (args.type == GenerateType.socket) {
      isMatchMode = true;
      needPack = false;
    }
    if (needPack) {
      zpDir = Directory(path.join(args.outDir.path, 'colorified'));
      if (!await zpDir.exists()) {
        await zpDir.create(recursive: true);
      }

      bpOutDir = Directory(path.join(zpDir.path, 'behaviour_pack'));
      if (!await bpOutDir.exists()) {
        await bpOutDir.create(recursive: true);
      }

      rpOutDir = Directory(path.join(zpDir.path, 'resources_pack'));
      if (!await rpOutDir.exists()) {
        await rpOutDir.create(recursive: true);
      }

      fnOutDir = Directory(path.join(bpOutDir.path, 'functions'));
      if (!await fnOutDir.exists()) {
        await fnOutDir.create(recursive: true);
      }

      args.pkName = args.pkName!.isEmpty ? 'Colorified' : args.pkName;
      args.pkAuth = args.pkAuth!.isEmpty ? 'Comeix Alpha' : args.pkAuth;
      args.pkDesc = args.pkDesc!.isEmpty ? DateTime.now().display() : args.pkDesc;

      /// Manifest
      await manifest(
        zpDir,
        PackageArg(
          name: args.pkName!,
          auth: args.pkAuth!,
          desc: args.pkDesc!,
        ),
      );

      /// Identicon
      receivePort.listen(
        (message) {
          if (message is Uint8List) {
            packIcon(zpDir, message);
          }
        },
      );
      sendPort.send(const Uuid().v4());

      /// Particle
      final ptDir = Directory(path.join(rpOutDir.path, 'particles'));
      if (!await ptDir.exists()) {
        await ptDir.create(recursive: true);
      }
      if (isMatchMode) {
        particleJsonModeMatch(ptDir, args.mappings);
      } else {
        particleJsonModeDust(ptDir);
      }
    } else {
      /// Useless
      zpDir = args.outDir;
      bpOutDir = args.outDir;

      /// Useful
      fnOutDir = args.outDir;
    }

    args.heig ??= 5;
    final zoom = args.heig! / height;
    List<ParticlePoint> points = [];
    for (int i = 0; i < res.length; i++) {
      final result = res[i];
      final tx = (width / 2 - result.x) * zoom;
      final ty = (height / 2 - result.y) * zoom;

      if (needRot) {
        final roted = rotate(MVector3(tx, 0, ty), MVector3(args.rx!, args.ry!, args.rz!));
        if (isMatchMode) {
          points.add(ParticlePoint(x: roted.x, y: roted.y, z: roted.z, pid: result.id));
        } else {
          final List<int> rgb = result.id.split(',').map((e) => e.toInt()!).toList();
          points.add(ParticlePoint(
            x: roted.x,
            y: roted.y,
            z: roted.z,
            r: rgb[0],
            g: rgb[1],
            b: rgb[2],
            pid: 'comeix:dust',
          ));
        }
      } else {
        if (plan == 0) {
          if (isMatchMode) {
            points.add(ParticlePoint(x: tx, y: ty, z: 0, pid: result.id));
          } else {
            final List<int> rgb = result.id.split(',').map((e) => e.toInt()!).toList();
            points.add(ParticlePoint(
              x: tx,
              y: ty,
              z: 0,
              r: rgb[0],
              g: rgb[1],
              b: rgb[2],
              pid: 'comeix:dust',
            ));
          }
        } else if (plan == 1) {
          if (isMatchMode) {
            points.add(ParticlePoint(x: tx, y: ty, z: 0, pid: result.id));
          } else {
            final List<int> rgb = result.id.split(',').map((e) => e.toInt()!).toList();
            points.add(ParticlePoint(
              x: tx,
              y: 0,
              z: ty,
              r: rgb[0],
              g: rgb[1],
              b: rgb[2],
              pid: 'comeix:dust',
            ));
          }
        } else if (plan == 2) {
          if (isMatchMode) {
            points.add(ParticlePoint(x: tx, y: ty, z: 0, pid: result.id));
          } else {
            final List<int> rgb = result.id.split(',').map((e) => e.toInt()!).toList();
            points.add(ParticlePoint(
              x: 0,
              y: tx,
              z: ty,
              r: rgb[0],
              g: rgb[1],
              b: rgb[2],
              pid: 'comeix:dust',
            ));
          }
        } else {
          throw Exception('Unexpected plan value passed in particle generator');
        }
      }
    }

    if (isMatchMode) {
      if (args.type == GenerateType.socket) {
        final List<String> commands = [];

        for (ParticlePoint point in points) {
          commands.add('particle ${point.pid} ~${point.x} ~${point.y} ~${point.z}');
        }

        sendPort.send(commands);
      } else {
        /// Make functions
        final Functionmaker fm = Functionmaker(dir: fnOutDir);

        for (int i = 0; i < points.length; i++) {
          final point = points[i];
          await fm.particle(point.x, point.y, point.z, point.pid);
          sendPort.send((i + 1) / points.length);
        }

        await fm.end();

        if (needPack) {
          await scriptModeMatch(bpOutDir, fm.fileCount);
        }
      }
    } else {
      /// Make scripts
      await scriptModeDust(bpOutDir, points);
      sendPort.send(1.0);
    }

    args.image = null;

    /// Archive
    if (needPack) {
      await pack(zpDir, args.outDir);
    }

    Isolate.exit();
  };
}
