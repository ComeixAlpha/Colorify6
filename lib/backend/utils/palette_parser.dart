import 'package:colorify/backend/abstracts/palette_entry.dart';

List<BlockPaletteEntry> parseBlockPalette(List<Map<String, Object>> v) {
  return v.map(
    (e) {
      final rgbs = e['average'] as List<int>;
      final cn = (e['cn'] ?? '')  as String;
      return BlockPaletteEntry(
        r: rgbs[0],
        g: rgbs[1],
        b: rgbs[2],
        id: e['id'] as String,
        cn: cn,
      );
    },
  ).toList();
}

List<BlockPaletteEntry> parseCarpetPalette(List<Map<String, Object>> v) => parseBlockPalette(v);

List<BlockPaletteEntry> parseMapPalette(List<Map<String, Object>> v) {
  return v.map(
    (e) {
      final rgbs = e['rgb'] as List<int>;
      final cn = (e['cn'] ?? '')  as String;
      return BlockPaletteEntry(
        r: rgbs[0],
        g: rgbs[1],
        b: rgbs[2],
        id: e['block'] as String,
        cn: cn,
      );
    },
  ).toList();
}
