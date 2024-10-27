import 'package:colorify/backend/abstracts/rgb.dart';
import 'package:image/image.dart';

class MatchResult {
  int x;
  int y;
  String id;
  MatchResult({
    required this.x,
    required this.y,
    required this.id,
  });
}

void readImage(Image image, double samp, void Function(int, int, int, int, num, num, num, num) fn) {
  final w = image.width;
  final h = image.height;
  final step = 1 ~/ samp;

  int rx = 0;
  int ry = 0;
  for (int x = 0; x < w; x += step) {
    for (int y = 0; y < h; y += step) {
      final pixel = image.getPixel(x, y);
      final r = pixel.r;
      final g = pixel.g;
      final b = pixel.b;
      final a = pixel.a;

      fn(x, y, rx, ry, r, g, b, a);
      ry++;
    }
    rx++;
    ry = 0;
  }
}

List<MatchResult> match(Image image, double samp, MatchResult? Function(int, int, RGBA) matcher) {
  final List<MatchResult> results = [];

  readImage(image, samp, (x, y, rx, ry, r, g, b, a) {
    RGBA? rgb = RGBA(
      r: r as int,
      g: g as int,
      b: b as int,
      a: a as int,
    );
    final res = matcher(x, y, rgb);
    if (res != null) {
      results.add(res);
    }
    rgb = null;
  });

  return results;
}
