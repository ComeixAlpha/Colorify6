import 'package:colorify/backend/abstracts/rgb.dart';
import 'package:colorify/backend/extensions/on_list.dart';
import 'package:image/image.dart' as img;

/// Floyd-Steinberg Dithering
img.Image dither(img.Image image, List<num> Function(List<num> target) findRGB) {
  final copy = image;

  final w = copy.width;
  final h = copy.height;

  const double coe1 = 7 / 16;
  const double coe2 = 3 / 16;
  const double coe3 = 5 / 16;
  const double coe4 = 1 / 16;

  for (int x = 0; x < w; x++) {
    for (int y = 0; y < h; y++) {
      final pixel = copy.getPixel(x, y);

      final pr = pixel.r;
      final pg = pixel.g;
      final pb = pixel.b;

      final foundPixel = findRGB([pr, pg, pb]);

      final fr = foundPixel[0];
      final fg = foundPixel[1];
      final fb = foundPixel[2];

      copy.setPixel(
        x,
        y,
        copy.getColor(
          fr.toInt(),
          fg.toInt(),
          fb.toInt(),
        ),
      );

      final er = pr - fr;
      final eg = pg - fg;
      final eb = pb - fb;

      if (x != 0 && y != h - 1) {
        final p = copy.getPixel(x - 1, y);
        copy.setPixel(
          x - 1,
          y,
          copy.getColor(
            (p.r + er * coe2).toInt(),
            (p.g + eg * coe2).toInt(),
            (p.b + eb * coe2).toInt(),
          ),
        );
      }
      if (x != w - 1 && y != h - 1) {
        final p1 = copy.getPixel(x + 1, y);
        final p2 = copy.getPixel(x + 1, y + 1);
        copy.setPixel(
          x + 1,
          y,
          copy.getColor(
            (p1.r + er * coe1).toInt(),
            (p1.g + eg * coe1).toInt(),
            (p1.b + eb * coe1).toInt(),
          ),
        );
        copy.setPixel(
          x + 1,
          y + 1,
          copy.getColor(
            (p2.r + er * coe4).toInt(),
            (p2.g + eg * coe4).toInt(),
            (p2.b + eb * coe4).toInt(),
          ),
        );
      }
      if (y != h - 1) {
        final p = copy.getPixel(x, y + 1);
        copy.setPixel(
          x,
          y + 1,
          copy.getColor(
            (p.r + er * coe3).toInt(),
            (p.g + eg * coe3).toInt(),
            (p.b + eb * coe3).toInt(),
          ),
        );
      }
    }
  }

  return copy;
}

List<List<RGBA>> ditherList(List<List<RGBA>> samples, List<num> Function(List<num> target) findRGB) {
  samples = [...samples];

  const double coe1 = 7 / 16;
  const double coe2 = 3 / 16;
  const double coe3 = 5 / 16;
  const double coe4 = 1 / 16;

  final w = samples.length;
  final h = samples[0].length;

  samples.enumerate(
    (x, row) {
      row.enumerate(
        (y, v) {
          final RGBA pixel = v;

          final pr = pixel.r;
          final pg = pixel.g;
          final pb = pixel.b;

          final foundPixel = findRGB([pr, pg, pb]);

          final fr = foundPixel[0];
          final fg = foundPixel[1];
          final fb = foundPixel[2];

          samples[x][y] = RGBA(
            r: fr.toInt(),
            g: fg.toInt(),
            b: fb.toInt(),
            a: v.a,
          );

          final er = pr - fr;
          final eg = pg - fg;
          final eb = pb - fb;

          if (x != 0 && y != h - 1) {
            final p = samples[x - 1][y];
            samples[x - 1][y] = RGBA(
              r: (p.r + er * coe2).toInt(),
              g: (p.g + eg * coe2).toInt(),
              b: (p.b + eb * coe2).toInt(),
              a: v.a,
            );
          }
          if (x != w - 1 && y != h - 1) {
            final p1 = samples[x + 1][y];
            final p2 = samples[x + 1][y + 1];

            samples[x + 1][y] = RGBA(
              r: (p1.r + er * coe1).toInt(),
              g: (p1.g + eg * coe1).toInt(),
              b: (p1.b + eb * coe1).toInt(),
              a: v.a,
            );
            samples[x + 1][y + 1] = RGBA(
              r: (p2.r + er * coe4).toInt(),
              g: (p2.g + eg * coe4).toInt(),
              b: (p2.b + eb * coe4).toInt(),
              a: v.a,
            );
          }
          if (y != h - 1) {
            final p = samples[x][y + 1];
            samples[x][y + 1] = RGBA(
              r: (p.r + er * coe3).toInt(),
              g: (p.g + eg * coe3).toInt(),
              b: (p.b + eb * coe3).toInt(),
              a: v.a,
            );
          }
        },
      );
    },
  );

  return samples;
}
