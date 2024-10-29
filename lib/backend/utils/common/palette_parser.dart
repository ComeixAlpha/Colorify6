import 'package:colorify/backend/abstracts/palette_entry.dart';
import 'package:colorify/backend/utils/common/hex.dart';

List<BlockPaletteEntry> parseBlockPalette(List<Map<String, Object>> v) {
  return v.map(
    (e) {
      final rgbs = e['average'] as List<int>;
      final cn = (e['cn'] ?? '未翻译') as String;
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

List<BlockPaletteEntry> parseMapPalette(Map<String, String> v) {
  final List<BlockPaletteEntry> parsed = [];

  for (String key in v.keys) {
    final hexString = v[key];
    if (hexString == '#0') {
      continue;
    }
    final rgbList = hexToRgb(hexString!);
    parsed.add(BlockPaletteEntry(
      cn: '无翻译',
      r: rgbList[0],
      g: rgbList[1],
      b: rgbList[2],
      id: key,
    ));
  }

  return parsed;
}
