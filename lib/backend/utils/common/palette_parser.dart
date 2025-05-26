import 'package:colorify/backend/abstracts/palette_entry.dart';
import 'package:colorify/backend/utils/common/hex.dart';

class PaletteParser {
  static List<BlockPaletteEntry> block(List<Map<String, Object>> v) {
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

  static List<BlockPaletteEntry> staircase(Map<String, String> v) {
    final List<BlockPaletteEntry> parsed = [];

    for (String key in v.keys) {
      final hexString = v[key];
      if (hexString == '#0') {
        continue;
      }
      final rgbList = hexToRgb(hexString!);
      parsed.add(BlockPaletteEntry(
        cn: '未翻译',
        r: rgbList[0],
        g: rgbList[1],
        b: rgbList[2],
        id: key,
      ));
    }

    return parsed;
  }

  static List<BlockPaletteEntry> carpet(List<Map<String, Object>> v) => PaletteParser.block(v);
}
