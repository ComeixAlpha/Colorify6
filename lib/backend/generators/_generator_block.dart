import 'dart:core';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'package:colorify/backend/abstracts/isolate_data_pack.dart';
import 'package:colorify/backend/abstracts/rgb.dart';
import 'package:colorify/backend/abstracts/rgbmapping.dart';
import 'package:colorify/backend/extensions/on_datetime.dart';
import 'package:colorify/backend/extensions/on_directory.dart';
import 'package:colorify/backend/extensions/on_iterable.dart';
import 'package:colorify/backend/extensions/on_list.dart';
import 'package:colorify/backend/extensions/on_sendport.dart';
import 'package:colorify/backend/generators/generator_block.dart';
import 'package:colorify/backend/generators/generator_package.dart';
import 'package:colorify/backend/utils/block_matrix.dart';
import 'package:colorify/backend/utils/flatten_manager.dart';
import 'package:colorify/backend/utils/floyd_steinberg.dart';
import 'package:colorify/backend/utils/functionmaker.dart';
import 'package:colorify/backend/utils/kdtree.dart';
import 'package:colorify/backend/utils/matchers/staircase_matcher.dart';
import 'package:colorify/backend/utils/offset_request.dart';
import 'package:colorify/backend/utils/sampler.dart';
import 'package:colorify/backend/utils/structure.dart';
import 'package:colorify/backend/utils/xyzswitcher.dart';
import 'package:colorify/frontend/components/processing/progress_indicator.dart';
import 'package:colorify/frontend/scaffold/bottombar.dart';
import 'package:image/image.dart';
import 'package:uuid/uuid.dart';
import 'package:vector_math/vector_math.dart';
import 'package:path/path.dart' as path;

GenBlockArguments? _args;

/// 参数接收器
void blockArgumentsReceiver(SendPort sendPort) async {
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

      if (dataPack.type == IsolateDataPackType.blockArguments) {
        /// 生成主体
        _generate(sendPort, dataPack.data);
        _args = dataPack.data;
      } else if (dataPack.type == IsolateDataPackType.identiconUint8List) {
        /// 生成 Identicon
        packIcon(_args!.outDir.concact('colorified'), dataPack.data, erp: false);
      } else {
        throw Exception('Unexpected isolate data type');
      }
    },
  );
}

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

/// 像素画生成器
Future<void> _generate(SendPort sendPort, GenBlockArguments args) async {
  /// 图像为空
  Image? image = args.image;
  if (image == null) {
    sendPort.sendData(
      IsolateDataPack(
        type: IsolateDataPackType.progressUpdate,
        data: ProgressData(state: 'Error', progress: -1),
      ),
    );
    return;
  }

  /// 自动采样
  if (args.samp == null) {
    final areaSize = image.width * image.height;
    if (areaSize > 20000) {
      args.samp = sqrt(20000 / areaSize);
    } else {
      args.samp = 1;
    }
  }

  /// 扁平化管理
  args.version ??= '1.20.80';

  /// 采样
  _updateProgress(sendPort, '采样中', 2);
  List<List<RGBA>> rgbamat = sampler(image, args.samp!);

  /// 抖动
  if (args.dithering) {
    _updateProgress(sendPort, '抖动中', 2);
    rgbamat = ditherList(rgbamat, (rgb) {
      return findRGB(rgb, args.palette);
    });
  }

  /// 匹配
  BlockMatrix blmx;
  if (args.stairType) {
    /// 阶梯式
    blmx = _buildStaircase(rgbamat, args, (v) {
      _updateProgress(sendPort, '构建阶梯式中', v);
    });
  } else {
    /// 扁平式
    _updateProgress(sendPort, '构建扁平式中', 2);
    blmx = _buildFlat(rgbamat, args);
  }

  /// 输出
  bool needPack = [args.pkName, args.pkAuth, args.pkDesc].any((e) => e!.isNotEmpty);
  if (args.type == GenerateType.socket) {
    needPack = false;
    args.useStruct = false;
  }

  if (args.type == GenerateType.file) {
    /// 以文件形式输出
    if (needPack) {
      _updateProgress(sendPort, '初始化包体中', 2);
      await _buildPack(sendPort, args);
    }
    if (args.useStruct) {
      _updateProgress(sendPort, '输出结构文件中', 2);
      await _writeStructure(blmx, needPack, args);
    } else {
      await _writeFunctionsAndScripts(blmx, needPack, args, (cur, all) {
        _updateProgress(sendPort, '输出函数中', cur / all);
      });
    }
    if (needPack) {
      final compressDir = args.outDir.concact('colorified');
      pack(compressDir, args.outDir);
    }
  } else {
    /// 用 WebSocket 输出
    sendPort.send(
      IsolateDataPack(
        type: IsolateDataPackType.socketCommands,
        data: _buildCommands(blmx, args),
      ),
    );
  }

  /// 完成
  _updateProgress(sendPort, '', 1);
}

BlockMatrix _buildStaircase(
  List<List<RGBA>> rgbamat,
  GenBlockArguments args,
  void Function(double) onProgress,
) {
  final BlockMatrix blmx = BlockMatrix();

  /// 偏移矩阵
  final ormx = OffsetRequestMatrix(
    width: rgbamat.length,
    height: rgbamat[0].length,
  );

  /// 匹配与偏移
  rgbamat.enumerate(
    (x, row) {
      row.enumerate(
        (z, rgba) {
          /// 显示进度
          onProgress((x * rgbamat[0].length + z) / rgbamat.length / rgbamat[0].length);

          /// 透明即为空
          if (rgba.a != 255) return;

          final matched = staircaseMatcher(rgba, args);
          ormx.orm[x][z].block = matched.block;

          final ormxEntry = ormx.orm[x][z];
          ormx.update(x, z + 1, ormxEntry.basey + ormxEntry.offset, matched.offset);
        },
      );
    },
  );

  ormx.archieve();

  /// 写入方块矩阵
  ormx.enumerate(
    (i, j, entry) {
      blmx.push(Block(x: i, y: entry.basey + entry.offset, z: j, block: entry.block));
    },
  );

  return blmx;
}

List<num> findRGB(List<num> rgb, List<RGBMapping> palette) {
  List<num> find = [];
  num mindis = double.infinity;
  for (RGBMapping entry in palette) {
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
}

BlockMatrix _buildFlat(List<List<RGBA>> rgbamat, GenBlockArguments args) {
  final BlockMatrix blmx = BlockMatrix();

  /// 初始化 KD 树
  final manager = FlattenManager.version(args.version!);
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
          return !manager.chs.map((v) => v.flattened).contains(e.id);
        } else {
          return true;
        }
      },
    ).toList(),
  );

  rgbamat.enumerate(
    (x, row) {
      row.enumerate(
        (z, rgba) {
          /// 透明即为空
          if (rgba.a != 255) return;

          final found = kdtree.findNearest(PaletteEntry(rgba.r, rgba.g, rgba.b, ''));

          if (found == null) {
            return;
          }

          final block = manager.getBlockWithStateOf(found.id);
          blmx.push(Block(x: x, y: 0, z: z, block: block));
        },
      );
    },
  );

  return blmx;
}

Future<void> _buildPack(SendPort sendPort, GenBlockArguments args) async {
  Directory zpdir = args.outDir.concact('colorified');
  if (!await zpdir.exists()) {
    await zpdir.create();
  }

  if (args.useStruct) {
    await zpdir.concact('structures').create();
  } else {
    await zpdir.concact('functions').create();
  }

  args.pkName = args.pkName!.isEmpty ? 'Colorified' : args.pkName;
  args.pkAuth = args.pkAuth!.isEmpty ? 'Comeix Alpha' : args.pkAuth;
  args.pkDesc = args.pkDesc!.isEmpty ? DateTime.now().display() : args.pkDesc;

  /// 清单
  await manifest(
    zpdir,
    PackageArg(
      name: args.pkName!,
      auth: args.pkAuth!,
      desc: args.pkDesc!,
    ),
    erp: false,
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

Future<void> _writeStructure(BlockMatrix blmx, bool needPack, GenBlockArguments args) async {
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
    },
  );

  Directory outDir;
  if (needPack) {
    outDir = args.outDir.concact('colorified/structures');
  } else {
    outDir = args.outDir;
  }

  final outpath = path.join(outDir.path, 'output.mcstructure');

  await struct.writeFile(outpath);
}

List<String> _buildCommands(BlockMatrix blmx, GenBlockArguments args) {
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
        commands.add('setblock ~${v.x + bos[0]} ~${v.y + bos[1]} ~${v.z + bos[2]} ${v.block.id} ${v.block.state}');
      } else {
        commands.add(
          'setblock ~${xyz[0] + bos[0]} ~${xyz[1] + bos[1]} ~${xyz[2] + bos[2]} ${v.block.id} ${v.block.state}',
        );
      }
    },
  );

  return commands;
}

Future<void> _writeFunctionsAndScripts(
  BlockMatrix blmx,
  bool needPack,
  GenBlockArguments args,
  void Function(int, int) onProgress,
) async {
  final List<String> commands = _buildCommands(blmx, args);

  Directory functionDir;
  if (needPack) {
    functionDir = args.outDir.concact('colorified/functions');
  } else {
    functionDir = args.outDir;
  }
  final fm = Functionmaker(dir: functionDir);
  final len = commands.length;
  await commands.enumerateAsync(
    (i, v) async {
      onProgress(i, len);
      await fm.command(v);
    },
  );
  await fm.end();

  if (needPack) {
    final size = blmx.size;
    await scriptTickingArea(
      args.outDir.concact('colorified'),
      fm.fileCount + 1,
      size.x.toInt(),
      size.y.toInt(),
      size.z.toInt(),
    );
  }
}