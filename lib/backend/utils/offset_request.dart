import 'package:colorify/backend/extensions/on_iterable.dart';
import 'package:colorify/backend/extensions/on_list.dart';

/// Records offset request from previous block(north one)
class OffsetEntry {
  // North block y pos
  late int basey;
  late int offset;
  late String id;
  OffsetEntry({
    required this.basey,
    required this.offset,
    required this.id,
  });

  OffsetEntry.empty() {
    basey = 0;
    offset = 0;
    id = '';
  }
}

/// Matrix consists of OffsetRequest(s)
/// Initialize as empty(invalid offset request filled)
class OffsetRequestMatrix {
  late final int width;
  late final int height;
  late final List<List<OffsetEntry>> orm;
  OffsetRequestMatrix({required this.width, required this.height}) {
    orm = List.generate(
      width,
      (_) => List.generate(
        height,
        (_) => OffsetEntry.empty(),
      ),
    );
  }

  OffsetEntry? getor(int x, int z) {
    if (x >= orm.length) return null;
    if (z >= orm[x].length) return null;
    return orm[x][z];
  }

  bool update(int x, int z, int? basey, int? offset) {
    if (x < 0 || x >= width || z < 0 || z >= height) {
      return false;
    }
    if (basey != null) {

    orm[x][z].basey = basey;
    }
    if (offset != null) {
    orm[x][z].offset = offset;

    }
    return true;
  }

  /// A column means the blocks under the same X pos
  List<int> _archieveColumn(int column) {
    /// Offsets from Z- to Z+
    List<int> offsets = orm[column].map((e) => e.offset).toList();

    /// Offset from Z+ to Z-
    List<int> offsetsRev = offsets.reversed.toList();

    /// Offset archieved. From Z+ to Z-
    List<int> archedOffsets = [];
    for (int i = 0; i < offsetsRev.length; i++) {
      final int offset = offsetsRev[i];
      final int previousSum = offsets.sublist(0, offsets.length - i).sum();

      int archedOffset;
      if (offset * previousSum < 0) {
        archedOffset = -previousSum;
      } else {
        archedOffset = offset;
      }

      archedOffsets.add(archedOffset);
    }

    return archedOffsets.reversed.toList();
  }

  void archieve() {
    for (int i = 0; i < width; i++) {
      _archieveColumn(i).enumerate(
        (j, v) {
          orm[i][j].offset = v;
          update(i, j + 1, orm[i][j].basey + v, null);
        },
      );
    }
  }

  void enumerate(void Function(int, int, OffsetEntry) fn) {
    for (int i = 0; i < width; i++) {
      for (int j = 0; j < height; j++) {
        fn(i, j, orm[i][j]);
      }
    }
  }
}
