import 'dart:math';

import 'package:colorify/backend/abstracts/rgb.dart';
import 'package:colorify/backend/extensions/on_iterable.dart';
import 'package:colorify/backend/extensions/on_list.dart';

class ColorDistance {
  int selected;

  ColorDistance(this.selected);

  num Function(RGBA x, RGBA y) get calculator {
    if (selected == 0) {
      return manhattan;
    } else if (selected == 1) {
      return rgbplus;
    } else {
      throw Exception();
    }
  }
}

/// 曼哈顿距离色差
int manhattan(RGBA x, RGBA y) {
  return [x.r - y.r, x.g - y.g, x.b - y.b].map((e) => e.abs()).sum();
}

/// RGB+色差公式
/// 杨振亚,王勇,杨振东,王成道. RGB 颜色空间的矢量-角度距离色差公式[J]. 计算机工程与应用，2010,46(6)
num rgbplus(RGBA x, RGBA y) {
  const num wr = 1;
  const num wg = 2;
  const num wb = 1;
  const num tiny = 1e-10;

  final num sumrgb = 1 / 3 * (x.r + y.r + x.g + y.g + x.b + y.b) + tiny;

  final num sr = min((x.r + y.r) / sumrgb, 1);
  final num sg = min((x.g + y.g) / sumrgb, 1);
  final num sb = min((x.b + y.b) / sumrgb, 1);

  final num theta = 2 /
      pi *
      acos(((x.r * y.r + x.g * y.g + x.b * y.b) /
              sqrt((pow(x.r, 2) + pow(x.g, 2) + pow(x.b, 2)) * (pow(y.r, 2) + pow(y.g, 2) + pow(y.b, 2)) + tiny))
          .clamp(-1, 1));

  final num deno = [
    (x.r - y.r).abs() / (x.r + y.r + tiny),
    (x.g - y.g).abs() / (x.g + y.g + tiny),
    (x.b - y.b).abs() / (x.b + y.b + tiny),
    tiny,
  ].sum();

  final num sthetar = ((x.r - y.r).abs() / (x.r + y.r)) / deno * pow(sr, 2);
  final num sthetag = ((x.g - y.g).abs() / (x.g + y.g)) / deno * pow(sg, 2);
  final num sthetab = ((x.b - y.b).abs() / (x.b + y.b)) / deno * pow(sb, 2);
  final num stheta = sthetar + sthetag + sthetab;
  final num sratio = [x.r, y.r, x.g, y.g, x.b, y.b].max() / 255;

  final num distance = sqrt([
            pow(sr, 2) * wr * pow((x.r - y.r), 2),
            pow(sg, 2) * wg * pow((x.g - y.g), 2),
            pow(sb, 2) * wb * pow((x.b - y.b), 2),
          ].sum() /
          (wr + wg + wb) /
          pow(255, 2) +
      stheta * sratio * pow(theta, 2));

  return distance;
}
