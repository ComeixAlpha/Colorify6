import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:colorify/backend/abstracts/block_with_state.dart';
import 'package:colorify/backend/abstracts/rgbmapping.dart';
import 'package:colorify/backend/extensions/on_datetime.dart';
import 'package:colorify/backend/extensions/on_iterable.dart';
import 'package:colorify/backend/extensions/on_list.dart';
import 'package:colorify/backend/extensions/on_string.dart';
import 'package:colorify/backend/generators/generator_package.dart';
import 'package:colorify/backend/providers/block.prov.dart';
import 'package:colorify/backend/utils/block_matrix.dart';
import 'package:colorify/backend/utils/flatten_manager.dart';
import 'package:colorify/backend/utils/floyd_steinberg.dart';
import 'package:colorify/backend/utils/functionmaker.dart';
import 'package:colorify/backend/utils/kdtree.dart';
import 'package:colorify/backend/utils/matcher.dart';
import 'package:colorify/backend/utils/offset_request.dart';
import 'package:colorify/backend/utils/structure.dart';
import 'package:colorify/backend/utils/xyzswitcher.dart';
import 'package:colorify/frontend/pages/block/block_arguments.dart';
import 'package:colorify/frontend/scaffold/bottombar.dart';
import 'package:image/image.dart';
import 'package:uuid/uuid.dart';
import 'package:vector_math/vector_math.dart';
import 'package:path/path.dart' as path;

class GenBlockArguments {
  Image? image;
  double? samp;
  String? pkName;
  String? pkAuth;
  String? pkDesc;
  String? version;
  List<int?>? basicOffset;
  final int plane;
  final bool stairType;
  bool useStruct;
  final bool dithering;
  final Directory outDir;
  final List<RGBMapping> palette;
  final GenerateType type;

  GenBlockArguments({
    required this.image,
    required this.outDir,
    required this.palette,
    required this.samp,
    required this.pkName,
    required this.pkAuth,
    required this.pkDesc,
    required this.version,
    required this.basicOffset,
    required this.plane,
    required this.stairType,
    required this.useStruct,
    required this.dithering,
    required this.type,
  });

  static GenBlockArguments from(
    Blockprov provider, {
    required GenerateType type,
    required Image? image,
    required Directory outDir,
  }) {
    return GenBlockArguments(
      type: type,
      image: image,
      outDir: outDir,
      palette: provider.filteredPalette,
      samp: btecSampling.text.toDouble(),
      pkName: btecpkname.text,
      pkAuth: btecpkauth.text,
      pkDesc: btecpkdesc.text,
      version: btecflattn.text,
      basicOffset: [
        btecbox.text.toInt(),
        btecboy.text.toInt(),
        btecboz.text.toInt(),
      ],
      plane: provider.plane,
      stairType: provider.stairType,
      useStruct: provider.useStruct,
      dithering: provider.dithering,
    );
  }
}

void Function(SendPort) bArgClosure(GenBlockArguments args) {
  return (SendPort sendPort) async {
    final ReceivePort receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);

    /// Record if all tasks has done
    bool icon = false;

    /// Image null error
    Image? image = args.image;
    if (image == null) {
      sendPort.send(-1.0);
      return;
    }

    /// Dithering
    if (args.dithering) {
      image = dither(image, (rgb) {
        List<num> find = [];
        num mindis = double.infinity;
        for (RGBMapping entry in args.palette) {
          num md = [
            (entry.r as num) - rgb[0],
            (entry.r as num) - rgb[1],
            (entry.r as num) - rgb[2],
          ].map((e) => e.abs().toDouble()).sum();

          if (md < mindis) {
            find = [
              entry.r as num,
              entry.r as num,
              entry.r as num,
            ];
            mindis = md;
          }
        }

        return find;
      });
    }

    /// Auto sampling
    if (args.samp == null) {
      final areaSize = image.width * image.height;
      if (areaSize > 20000) {
        args.samp = sqrt(20000 / areaSize);
      } else {
        args.samp = 1;
      }
    }

    /// Flattening
    args.version ??= '1.20.80';
    final fm = FlattenManager.version(args.version!);

    final blmx = BlockMatrix();
    if (args.stairType) {
      final step = 1 ~/ args.samp!;
      final matw = image.width ~/ step;
      final math = image.height ~/ step;
      final ormx = OffsetRequestMatrix(width: matw + 1, height: math + 1);
      readImage(
        image,
        args.samp!,
        (x, y, rx, ry, r, g, b, a) {
          if (a != 255) return;

          /// T: Target
          final List<int> tRGB = [r as int, g as int, b as int];
          BlockWithState? tblock;
          int? ty;
          double minmdRecord = double.infinity;
          for (RGBMapping entry in args.palette) {
            final sRGB = [entry.r, entry.g, entry.b];
            final pRGB = sRGB.map((e) => e * 220 / 255).toList();
            final lRGB = sRGB.map((e) => e * 180 / 255).toList();

            final smd = sRGB.mapInEnumerate((i, v) => (v - tRGB[i]).abs()).sum();
            final pmd = pRGB.mapInEnumerate((i, v) => (v - tRGB[i]).abs()).sum();
            final lmd = lRGB.mapInEnumerate((i, v) => (v - tRGB[i]).abs()).sum();

            final minmd = min(smd, min(pmd, lmd)).toDouble();

            if (minmd > minmdRecord) {
              continue;
            }

            final block = fm.getBlockWithStateOf(entry.id);

            /// Not support block states
            if (args.useStruct || args.type == GenerateType.socket && (block.stateString ?? '').isNotEmpty) {
              continue;
            }

            tblock = block;
            minmdRecord = minmd;

            final ormxEntry = ormx.orm[rx][ry];
            final basey = ormxEntry.basey;
            final offset = ormxEntry.offset;
            final offsetedy = basey + offset;

            ty = offsetedy;

            if (minmd == smd) {
              ormx.update(rx, ry + 1, ty, 2);
            } else if (minmd == pmd) {
              ormx.update(rx, ry + 1, ty, 0);
            } else {
              ormx.update(rx, ry + 1, ty, -2);
            }
          }

          if (ty == null || tblock == null) {
            throw Exception();
          }

          ormx.orm[rx][ry].block = tblock;
        },
      );

      // ormx.archieve();

      ormx.enumerate(
        (i, j, entry) {
          blmx.push(Block(x: i, y: entry.basey + entry.offset, z: j, block: entry.block));
        },
      );
    } else {
      final kdtree = KDTree(
        List.generate(
          args.palette.length,
          (i) => PaletteEntry(
            args.palette[i].r,
            args.palette[i].g,
            args.palette[i].b,
            args.palette[i].id,
          ),
        ).where(
          (e) {
            if (args.useStruct) {
              return !fm.chs.map((v) => v.flattened).contains(e.id);
            } else {
              return true;
            }
          },
        ).toList(),
      );
      final step = 1 ~/ args.samp!;
      final rw = image.width ~/ step;
      final rh = image.height ~/ step;
      readImage(
        image,
        args.samp!,
        (x, y, rx, ry, r, g, b, a) {
          if (a != 255) return;

          final nearest = kdtree.findNearest(PaletteEntry(r as int, g as int, b as int, ''));

          if (nearest == null) {
            return;
          }

          final tx = rw - rx;
          final ty = rh - ry;

          final block = fm.getBlockWithStateOf(nearest.id);
          blmx.push(Block(x: tx, y: 0, z: ty, block: block));
        },
      );
    }

    /// If Pack
    bool needPack = [args.pkName, args.pkAuth, args.pkDesc].any((e) => e!.isNotEmpty);
    if (args.type == GenerateType.socket) {
      needPack = false;
    }

    /// Directory
    final Directory topdir = args.outDir;
    Directory zpdir;
    Directory fndir;
    Directory strdir;
    if (needPack) {
      zpdir = Directory(path.join(topdir.path, 'colorified'));
      if (!await zpdir.exists()) {
        await zpdir.create();
      }

      fndir = Directory(path.join(zpdir.path, 'functions'));
      if (!await fndir.exists()) {
        await fndir.create();
      }
      if (args.useStruct) {
        strdir = Directory(path.join(zpdir.path, 'structures'));
        if (!await strdir.exists()) {
          await strdir.create();
        }
      } else {
        strdir = topdir;
      }

      args.pkName = args.pkName!.isEmpty ? 'Colorified' : args.pkName;
      args.pkAuth = args.pkAuth!.isEmpty ? 'Comeix Alpha' : args.pkAuth;
      args.pkDesc = args.pkDesc!.isEmpty ? DateTime.now().display() : args.pkDesc;

      /// Manifest
      await manifest(
        zpdir,
        PackageArg(
          name: args.pkName!,
          auth: args.pkAuth!,
          desc: args.pkDesc!,
        ),
        erp: false,
      );

      /// Identicon
      receivePort.listen(
        (message) async {
          if (message is Uint8List) {
            await packIcon(zpdir, message, erp: false);
            icon = true;
          }
        },
      );
      sendPort.send(const Uuid().v4());
    } else {
      zpdir = topdir;
      strdir = topdir;
      fndir = topdir;
    }

    if (args.useStruct) {
      Structure struct;
      if (args.stairType) {
        struct = Structure(blmx.size);
      } else {
        final xyz = xyzswitcher(args.plane, [
          blmx.size.x,
          blmx.size.y,
          blmx.size.z,
        ]);
        struct = Structure(Vector3(
          xyz[0],
          xyz[1],
          xyz[2],
        ));
      }
      blmx.blocks.enumerate(
        (i, v) {
          if (args.stairType) {
            struct.setBlock(
              Vector3(
                v.x.toDouble(),
                v.y.toDouble(),
                v.z.toDouble(),
              ),
              v.block.id,
            );
          } else {
            final xyz = xyzswitcher(args.plane, [v.x, v.y, v.z]);
            struct.setBlock(
              Vector3(
                xyz[0].toDouble(),
                xyz[1].toDouble(),
                xyz[2].toDouble(),
              ),
              v.block.id,
            );
          }
          sendPort.send((i + 1) / blmx.blocks.length);
        },
      );

      final outpath = path.join(strdir.path, 'output.mcstructure');

      await struct.writeFile(outpath);
    } else {
      final List<String> commands = [];
      final List<int> bo = [
        args.basicOffset![0] ?? 0,
        args.basicOffset![1] ?? 0,
        args.basicOffset![2] ?? 0,
      ];
      final List<int> bos = xyzswitcher(args.plane, bo);
      blmx.blocks.enumerate(
        (i, v) {
          final List<int> xyz = xyzswitcher(args.plane, [v.x, v.y, v.z]);
          if (args.stairType) {
            commands.add('setblock ~${v.x + bo[0]} ~${v.y + bo[1]} ~${v.z + bo[2]} ${v.block.id} ${v.block.state}');
          } else {
            commands.add(
              'setblock ~${xyz[0] + bos[0]} ~${xyz[1] + bos[1]} ~${xyz[2] + bos[2]} ${v.block.id} ${v.block.state}',
            );
          }
        },
      );

      if (args.type == GenerateType.file) {
        /// Make files

        final fm = Functionmaker(dir: fndir);
        await commands.enumerateAsync(
          (i, v) async {
            await fm.command(v);

            sendPort.send((i + 1) / commands.length);
          },
        );
        await fm.end();

        if (needPack) {
          final size = blmx.size;
          await scriptTickingArea(
            zpdir,
            fm.fileCount + 1,
            size.x.toInt(),
            size.y.toInt(),
            size.z.toInt(),
          );
        }
      } else {
        /// Send to Root Isolate for WebSocket
        sendPort.send(commands);
      }
    }

    args.image = null;

    /// If pack enabled, wait for pack icon to generate
    if (needPack) {
      Future<void> runUnless() async {
        Future.delayed(
          const Duration(milliseconds: 10),
          () async {
            if (!icon) {
              runUnless();
            } else {
              await pack(zpdir, args.outDir, suffix: 'mcpack');
              Isolate.exit();
            }
          },
        );
      }

      runUnless();
    } else {
      Isolate.exit();
    }
  };
}
