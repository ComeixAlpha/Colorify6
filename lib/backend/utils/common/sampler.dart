import 'package:colorify/backend/abstracts/rgb.dart';
import 'package:image/image.dart';

List<List<RGBA>> readImageAsRGBAList(Image image) {
  final w = image.width;
  final h = image.height;

  final List<List<RGBA>> rgbamat = [];
  int relativex = 0;
  for (int x = 0; x < w; x++) {
    rgbamat.add([]);
    for (int y = 0; y < h; y++) {
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

  return rgbamat.reversed.toList();
}
