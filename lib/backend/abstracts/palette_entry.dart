import 'package:colorify/backend/abstracts/rgbmapping.dart';

class BlockPaletteEntry extends RGBMapping {
  String cn;
  BlockPaletteEntry({
    required this.cn,
    required super.r,
    required super.g,
    required super.b,
    required super.id,
  });
}
