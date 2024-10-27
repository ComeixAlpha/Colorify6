import 'dart:math';

import 'package:colorify/backend/abstracts/block_with_state.dart';
import 'package:colorify/backend/abstracts/rgb.dart';
import 'package:colorify/backend/abstracts/rgbmapping.dart';
import 'package:colorify/backend/extensions/on_iterable.dart';
import 'package:colorify/backend/extensions/on_list.dart';
import 'package:colorify/backend/generators/generator_block.dart';
import 'package:colorify/backend/utils/flatten_manager.dart';
import 'package:colorify/frontend/scaffold/bottombar.dart';

class StaircaseMatchResult {
  int offset;
  BlockWithState block;

  StaircaseMatchResult({
    required this.offset,
    required this.block,
  });
}

StaircaseMatchResult staircaseMatcher(RGBA rgba, GenBlockArguments args) {
  final List<int> tRGB = [rgba.r, rgba.g, rgba.b];
  final FlattenManager manager = FlattenManager.version(args.version!);

  /// 匹配到的值
  BlockWithState? block;
  int? offset;

  /// 最小距离记录
  double minmdRecord = double.infinity;

  /// 遍历匹配
  for (RGBMapping entry in args.palette) {
    /// 三种阴影下的 RGB
    final sRGB = [entry.r, entry.g, entry.b];
    final pRGB = sRGB.map((e) => e * 220 / 255).toList();
    final lRGB = sRGB.map((e) => e * 180 / 255).toList();

    /// 曼哈顿距离
    final smd = sRGB.mapInEnumerate((i, v) => (v - tRGB[i]).abs()).sum();
    final pmd = pRGB.mapInEnumerate((i, v) => (v - tRGB[i]).abs()).sum();
    final lmd = lRGB.mapInEnumerate((i, v) => (v - tRGB[i]).abs()).sum();

    final minmd = min(smd, min(pmd, lmd)).toDouble();

    if (minmd > minmdRecord) {
      continue;
    }

    final found = manager.getBlockWithStateOf(entry.id);

    /// 结构与 WebSocket 不支持方块状态
    if (args.useStruct || args.type == GenerateType.socket && (found.stateString ?? '').isNotEmpty) {
      continue;
    }

    block = found;
    minmdRecord = minmd;

    if (minmd == smd) {
      offset = 2;
    } else if (minmd == pmd) {
      offset = 0;
    } else {
      offset = -2;
    }
  }

  return StaircaseMatchResult(offset: offset!, block: block!);
}
