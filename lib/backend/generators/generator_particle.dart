import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'package:colorify/backend/abstracts/genparticleargs.dart';
import 'package:colorify/backend/abstracts/isolate_data_pack.dart';
import 'package:colorify/backend/abstracts/particle_point.dart';
import 'package:colorify/backend/abstracts/rgb.dart';
import 'package:colorify/backend/abstracts/rgbmapping.dart';
import 'package:colorify/backend/assets/js/script_in_dust_mode.dart';
import 'package:colorify/backend/assets/js/script_in_match_mode.dart';
import 'package:colorify/backend/assets/json/dust_particle.dart';
import 'package:colorify/backend/assets/json/rgb_particle.dart';
import 'package:colorify/backend/extensions/on_datetime.dart';
import 'package:colorify/backend/extensions/on_directory.dart';
import 'package:colorify/backend/extensions/on_iterable.dart';
import 'package:colorify/backend/generators/generator_package.dart';
import 'package:colorify/backend/providers/particle.prov.dart';
import 'package:colorify/backend/utils/algo/rotator.dart';
import 'package:colorify/backend/utils/common/math.dart';
import 'package:colorify/backend/utils/common/xyzswitcher.dart';
import 'package:colorify/backend/utils/minecraft/functionmaker.dart';
import 'package:colorify/frontend/components/processing/progress_indicator.dart';
import 'package:colorify/frontend/scaffold/bottombar.dart';
import 'package:image/image.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;

GenParticleArguments? _args;
bool _isPackIconGenerated = false;

/// 参数接收器
void particleArgumentsReceiver(SendPort sendPort) async {
  /// 发送接收端口
  final ReceivePort receivePort = ReceivePort();
  sendPort.send(
    IsolateDataPack(
      type: IsolateDataPackType.sendPort,
      data: receivePort.sendPort,
    ),
  );

  /// 添加监听
  receivePort.listen(
    (recv) {
      IsolateDataPack dataPack = recv as IsolateDataPack;

      if (dataPack.type == IsolateDataPackType.particleArguments) {
        /// 生成主体
        _generate(sendPort, dataPack.data);
        _args = dataPack.data;
      } else if (dataPack.type == IsolateDataPackType.identiconUint8List) {
        /// 生成 Identicon
        packIcon(_args!.outDir.concact('colorified'), dataPack.data, erp: true)
            .then((v) => _isPackIconGenerated = true);
      } else {
        throw Exception('Unexpected isolate data type');
      }
    },
  );
}

/// 进度更新器
void _updateProgress(SendPort sendPort, String state, double v) {
  sendPort.send(
    IsolateDataPack(
      type: IsolateDataPackType.progressUpdate,
      data: ProgressData(
        state: state,
        progress: v,
      ),
    ),
  );
}

/// 粒子画生成器
Future<void> _generate(SendPort sendPort, GenParticleArguments args) async {
  /// 重置包图标生成状态
  _isPackIconGenerated = false;

  /// 图像为空
  Image? image = args.image;
  if (image == null) {
    sendPort.send(
      IsolateDataPack(
        type: IsolateDataPackType.progressUpdate,
        data: ProgressData(state: 'Error', progress: -1),
      ),
    );
    return;
  }

  /// 自动尺寸
  args.size = _autoSize(image, args.size);
  final Interpolation interpolation = _getInterpolation(args.interpolation);
  image = copyResize(
    image,
    width: args.size[0],
    height: args.size[1],
    maintainAspect: true,
    interpolation: interpolation,
  );

  /// 冲突处理
  bool needPack = [args.pkName, args.pkAuth, args.pkDesc].any((e) => e!.isNotEmpty);
  if (args.type == GenerateType.socket) {
    args.mode = GenerateMode.match;
    needPack = false;
  }
  if (args.mode == GenerateMode.dust) {
    needPack = true;
  }

  /// 匹配
  _updateProgress(sendPort, '匹配中', 2);
  List<ParticlePoint> points = _matchParticles(image, args);

  /// 无匹配 生成结束
  if (points.isEmpty) {
    sendPort.send(
      IsolateDataPack(
        type: IsolateDataPackType.progressUpdate,
        data: ProgressData(state: '', progress: 1.0),
      ),
    );
  }

  /// 变换
  _updateProgress(sendPort, '变换中', 2);
  final bool needRot = [args.rx, args.ry, args.rz].any((e) => e != null);
  if (needRot) {
    args.rx ??= 0;
    args.ry ??= 0;
    args.rz ??= 0;
    points = _rotateTo(points, Vector3(args.rx!, args.ry!, args.rz!));
  } else {
    points = _transformPlane(points, args.plane);
  }

  args.heig ??= 5.0;
  points = _scale(points, args.heig! / image.height);

  /// 构建
  if (needPack) {
    /// 构建包体
    await _buildPack(sendPort, args);

    /// 生成粒子
    _updateProgress(sendPort, '生成粒子中', 2);
    _buildParticles(args);
  }

  /// 构建命令/脚本
  if (args.type == GenerateType.file) {
    if (args.mode == GenerateMode.match) {
      final int fileCount = await _buildFunctions(points, needPack, args, (cur, all) {
        _updateProgress(sendPort, '生成函数中', cur / all);
      });
      if (needPack) {
        await _buildScriptInMatchMode(fileCount, args);
      }
    } else {
      await _buildScriptInDustMode(points, args, (cur, all) {
        _updateProgress(sendPort, '生成脚本中', cur / all);
      });
    }
    if (needPack) {
      final compressDir = args.outDir.concact('colorified');
      await pack(compressDir, args.outDir);
    }
  }

  /// WS
  if (args.type == GenerateType.socket) {
    final commands = _buildWebSocketCommands(points, args);
    sendPort.send(IsolateDataPack(type: IsolateDataPackType.socketCommands, data: commands));
  }

  /// 等待图标生成完成
  _updateProgress(sendPort, '最后的步骤', 2);
  Future<void> waitUntilIconGenerated() async {
    if (_isPackIconGenerated) {
      sendPort.send(
        IsolateDataPack(
          type: IsolateDataPackType.progressUpdate,
          data: ProgressData(state: '', progress: 1.0),
        ),
      );
      Isolate.exit();
    } else {
      Future.delayed(const Duration(milliseconds: 10), waitUntilIconGenerated);
    }
  }

  waitUntilIconGenerated();
}

/// 自动尺寸裁剪
List<int> _autoSize(Image image, List<int?> origin) {
  final w = image.width;
  final h = image.height;
  if (origin.every((e) => e == null)) {
    final zoomFactor = sqrt(20000 / w / h);
    final int zw = (w * zoomFactor).floor();
    final int zh = (h * zoomFactor).floor();
    return [zw, zh];
  } else if (origin[0] == null) {
    final zoomFactor = origin[1]! / h;
    final int zw = (w * zoomFactor).round();
    return [zw, origin[1]!];
  } else if (origin[1] == null) {
    final zoomFactor = origin[0]! / w;
    final int zh = (h * zoomFactor).round();
    return [origin[0]!, zh];
  } else {
    return [origin[0]!, origin[1]!];
  }
}

/// 获取插值函数枚举
Interpolation _getInterpolation(int index) {
  switch (index) {
    case 0:
      return Interpolation.nearest;
    case 1:
      return Interpolation.cubic;
    case 2:
      return Interpolation.linear;
    case 3:
      return Interpolation.average;
    default:
      throw Exception('Unexpected interpolation index');
  }
}

/// 匹配粒子
List<ParticlePoint> _matchParticles(Image image, GenParticleArguments args) {
  final List<ParticlePoint> points = [];

  final int imagew = image.width;
  final int imageh = image.height;

  for (int x = 0; x < imagew; x++) {
    for (int y = 0; y < imageh; y++) {
      final pixel = image.getPixel(x, y);
      final pr = pixel.r;
      final pg = pixel.g;
      final pb = pixel.b;

      /// 坐标中心化
      final mx = imagew / 2 - x;
      final my = imageh / 2 - y;

      /// 尘模式记录原像素精确色值
      if (args.mode == GenerateMode.dust) {
        points.add(ParticlePoint(
          x: mx.toDouble(),
          y: my.toDouble(),
          z: 0,
          pid: 'comeix:dust',
          rgb: RGBA(
            r: pr.toInt(),
            g: pg.toInt(),
            b: pb.toInt(),
          ),
        ));
        continue;
      }

      /// 匹配模式
      String matched = '';
      num mindist = double.infinity;
      for (RGBMapping entry in args.mappings) {
        final er = entry.r;
        final eg = entry.g;
        final eb = entry.b;

        final dist = [pr - er, pg - eg, pb - eb].map((e) => e.abs()).sum();

        if (dist <= 30 && dist < mindist) {
          matched = entry.id;
          mindist = dist;
        }
      }
      if (matched.isNotEmpty) {
        points.add(ParticlePoint(
          x: mx.toDouble(),
          y: my.toDouble(),
          z: 0,
          pid: matched,
        ));
      }
    }
  }

  return points;
}

/// 缩放
List<ParticlePoint> _scale(List<ParticlePoint> origin, double factor) {
  return origin.map(
    (e) {
      e.x *= factor;
      e.y *= factor;
      e.z *= factor;
      return e;
    },
  ).toList();
}

/// 平面切换
List<ParticlePoint> _transformPlane(List<ParticlePoint> origin, int toPlaneIndex) {
  return origin.map(
    (e) {
      final transformed = xzswitcher(toPlaneIndex, [e.x, e.y, 0.0]);
      e.x = transformed[0];
      e.y = transformed[1];
      e.z = transformed[2];
      return e;
    },
  ).toList();
}

/// 旋转
List<ParticlePoint> _rotateTo(List<ParticlePoint> origin, Vector3 vec) {
  return origin.map(
    (e) {
      final originPoint = Vector3(e.x, e.y, e.z);
      final rotated = rotate(originPoint, vec);
      e.x = rotated.x;
      e.y = rotated.y;
      e.z = rotated.z;
      return e;
    },
  ).toList();
}

/// 初始化包体结构
Future<void> _buildPack(SendPort sendPort, GenParticleArguments args) async {
  Directory zpDir = args.outDir.concact('colorified');
  await zpDir.createIfNotExist();

  Directory bpDir = zpDir.concact('behaviour_pack');
  await bpDir.createIfNotExist();

  Directory rpDir = zpDir.concact('resources_pack');
  await rpDir.createIfNotExist();

  Directory scriptDir = bpDir.concact('scripts');
  await scriptDir.createIfNotExist();

  Directory particleDir = rpDir.concact('particles');
  await particleDir.createIfNotExist();

  if (args.mode == GenerateMode.match) {
    Directory funcDir = bpDir.concact('functions');
    await funcDir.createIfNotExist();
  }

  args.pkName = args.pkName!.isEmpty ? 'Colorified' : args.pkName;
  args.pkAuth = args.pkAuth!.isEmpty ? 'Comeix Alpha' : args.pkAuth;
  args.pkDesc = args.pkDesc!.isEmpty ? DateTime.now().display() : args.pkDesc;

  /// 清单
  await manifest(
    zpDir,
    PackageArg(
      name: args.pkName!,
      auth: args.pkAuth!,
      desc: args.pkDesc!,
    ),
    erp: true,
  );

  /// 图标
  final uuid = const Uuid().v4();
  sendPort.send(
    IsolateDataPack(
      type: IsolateDataPackType.identiconData,
      data: uuid,
    ),
  );
}

/// 生成粒子 Json
Future<void> _buildParticles(GenParticleArguments args) async {
  final particleDir = args.outDir.concact('colorified/resources_pack/particles');

  if (args.mode == GenerateMode.dust) {
    await File(path.join(particleDir.path, 'colorify.dust.json')).writeAsString(jsonEncode(dustparticle));
    return;
  }

  for (RGBMapping entry in args.mappings) {
    Map json = Map.from(rgbparticle);
    ((json['particle_effect'] as Map<String, Object>)['description'] as Map<String, Object>)['identifier'] = entry.id;
    (((json['particle_effect'] as Map<String, Object>)['components']
        as Map<String, Object>)['minecraft:particle_appearance_tinting'] as Map<String, List<int>>)['color'] = [
      entry.r,
      entry.g,
      entry.b,
      1,
    ];

    await File(
      path.join(particleDir.path, '${entry.id.replaceAll(':', '.')}.json'),
    ).writeAsString(
      jsonEncode(json),
    );
  }
}

/// 生成函数文件
Future<int> _buildFunctions(
  List<ParticlePoint> points,
  bool needPack,
  GenParticleArguments args,
  void Function(int, int) onPregrss,
) async {
  Directory funcDir;
  if (needPack) {
    funcDir = args.outDir.concact('colorified/behaviour_pack/functions');
  } else {
    funcDir = args.outDir;
  }
  final Functionmaker maker = Functionmaker(dir: funcDir);
  for (int i = 0; i < points.length; i++) {
    final point = points[i];
    onPregrss(i + 1, points.length);
    await maker.particle(point.x, point.y, point.z, point.pid);
  }

  await maker.end();

  return maker.fileCount;
}

/// 生成自动执行粒子生成命令的脚本
Future<void> _buildScriptInMatchMode(int fileCount, GenParticleArguments args) async {
  String runCommands = '';
  for (int i = 0; i < fileCount; i++) {
    runCommands += '\tentity.runCommand(\'function output_$i\');';
    if (i != fileCount - 1) {
      runCommands += '\n';
    }
  }

  final script = getScriptInMatchMode(runCommands);
  final scriptDir = args.outDir.concact('colorified/behaviour_pack/scripts');
  final scriptPath = path.join(scriptDir.path, 'index.js');
  await File(scriptPath).writeAsString(script);
}

/// 生成控制尘埃粒子的脚本
Future<void> _buildScriptInDustMode(
  List<ParticlePoint> points,
  GenParticleArguments args,
  void Function(int, int) onProgress,
) async {
  final scriptDir = args.outDir.concact('colorified/behaviour_pack/scripts');
  final scriptPath = path.join(scriptDir.path, 'index.js');
  final script = File(scriptPath);
  final sink = script.openWrite();

  sink.write(getScriptInDustMode(0));
  await sink.flush();

  for (int i = 0; i < points.length; i++) {
    onProgress(i, points.length);

    final point = points[i];
    final r = point.rgb!.r / 255;
    final g = point.rgb!.g / 255;
    final b = point.rgb!.b / 255;
    String particle = '\t{ x: ${point.x}, y: ${point.y}, z: ${point.z}, r: $r, g: $g, b: $b },\n';

    sink.write(particle);
    await sink.flush();
  }

  sink.write(getScriptInDustMode(1));

  await sink.flush();
  await sink.close();
}

/// 生成用于 WebSocket 的命令
List<String> _buildWebSocketCommands(List<ParticlePoint> points, GenParticleArguments args) {
  List<String> commands = [];
  for (ParticlePoint point in points) {
    commands.add('particle ${point.pid} ~${point.x} ~${point.y} ~${point.z}');
  }
  return commands;
}
