import 'package:colorify/backend/abstracts/rgb.dart';
import 'package:image/image.dart';

List<List<RGBA>> sampler(Image image, double sampling) {
  final w = image.width;
  final h = image.height;
  final step = 1 ~/ sampling;

  final List<List<RGBA>> rgbamat = [];
  int relativex = 0;
  for (int x = 0; x < w; x += step) {
    rgbamat.add([]);
    for (int y = 0; y < h; y += step) {
      final pixel = image.getPixel(x, y);
      final r = pixel.r;
      final g = pixel.g;
      final b = pixel.b;
      final a = pixel.a;
      rgbamat[relativex].add(
        RGBA(
          r: r as int,
          g: g as int,
          b: b as int,
          a: a as int,
        ),
      );
    }
    rgbamat[relativex] = rgbamat[relativex].reversed.toList();
    relativex++;
  }

  return rgbamat;
}
