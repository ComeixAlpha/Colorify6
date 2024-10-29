import 'dart:math';

import 'package:colorify/backend/abstracts/block_with_state.dart';
import 'package:colorify/backend/abstracts/genblockargs.dart';
import 'package:colorify/backend/abstracts/rgb.dart';
import 'package:colorify/backend/abstracts/rgbmapping.dart';
import 'package:colorify/backend/utils/algo/color_distance.dart';
import 'package:colorify/backend/utils/minecraft/flatten_manager.dart';
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
  final RGBA tRGB = rgba;
  final FlattenManager manager = FlattenManager.version(args.version!);

  /// 匹配到的值
  BlockWithState? block;
  int? offset;

  /// 最小距离记录
  double minmdRecord = double.infinity;

  /// 遍历匹配
  for (RGBMapping entry in args.palette) {
    /// 三种阴影下的 RGB
    final List<int> rgbList = [entry.r, entry.g, entry.b];
    final RGBA sRGB = RGBA.fromRGBList(rgbList);
    final RGBA pRGB = RGBA.fromRGBList(rgbList.map((e) => e * 220 ~/ 255).toList());
    final RGBA lRGB = RGBA.fromRGBList(rgbList.map((e) => e * 180 ~/ 255).toList());

    /// 曼哈顿距离
    ColorDistance cd = ColorDistance(args.colordistance);
    num smd = cd.calculator(sRGB, tRGB);
    num pmd = cd.calculator(pRGB, tRGB);
    num lmd = cd.calculator(lRGB, tRGB);

    if ([smd, pmd, lmd].any((e) => e.isNaN)) {
      cd = ColorDistance(0);
      smd = cd.calculator(sRGB, tRGB);
      pmd = cd.calculator(pRGB, tRGB);
      lmd = cd.calculator(lRGB, tRGB);
    }

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
