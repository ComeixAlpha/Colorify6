import 'dart:math';

import 'package:colorify/backend/abstracts/block_with_state.dart';
import 'package:colorify/backend/extensions/on_list.dart';

/// 偏移单元，储存着来自上一个方块的偏移请求
class OffsetEntry {
  // North block y pos
  late int basey;
  late int offset;
  late BlockWithState block;
  OffsetEntry({
    required this.basey,
    required this.offset,
    required this.block,
  });

  OffsetEntry.empty() {
    basey = 0;
    offset = 0;
    block = BlockWithState(id: '');
  }
}

/// 单调单元
class MonotoneEntry {
  int offset;
  int rv;

  MonotoneEntry({required this.offset, required this.rv});

  @override
  String toString() {
    return '${offset >= 0 ? '+$offset' : offset}:$rv';
  }
}

/// 偏移（请求）矩阵
/// 初始化为空矩阵
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

  /// 压缩一列的偏移
  /// 一个 列/Column 是指 X 坐标相等的 Z 轴的一列方块
  List<int> _archieveColumn(int column) {
    List<int> compressed = [];

    /// 从 Z- 到 Z+ 的偏移列
    List<int> offsets = orm[column].map((e) => e.offset).toList();

    /// 单调列
    int rv = 0;
    int maxv = 0;
    int minv = 0;
    List<List<MonotoneEntry>> monotones = [];
    bool increase = true;
    for (int i = 0; i < offsets.length; i++) {
      final e = offsets[i];
      rv += e;

      maxv = max(maxv, rv);
      minv = min(minv, rv);

      if (i == 0) {
        monotones.add([MonotoneEntry(offset: e, rv: rv)]);
        continue;
      }

      if (e == 0) {
        monotones[monotones.length - 1].add(MonotoneEntry(offset: e, rv: rv));
        continue;
      }

      final isIncreasing = e >= 0;

      if (i == 1) {
        increase = isIncreasing;
        monotones[0].add(MonotoneEntry(offset: e, rv: rv));
        continue;
      }

      if (isIncreasing == increase) {
        monotones[monotones.length - 1].add(MonotoneEntry(offset: e, rv: rv));
      } else {
        monotones.add([MonotoneEntry(offset: e, rv: rv)]);
        increase = isIncreasing;
      }
    }

    /// 偏移
    int maxlen = 0;
    int lenestmaxv = 0;
    int lenestminv = 0;
    for (int i = 0; i < monotones.length; i++) {
      if (monotones[i].length > maxlen) {
        maxlen = monotones[i].length;
        final fv = monotones[i][0].rv;
        final lv = monotones[i][monotones[i].length - 1].rv;

        lenestmaxv = max(fv, lv);
        lenestminv = min(fv, lv);
      }
    }

    int previousOffset = 0;
    for (int i = 0; i < monotones.length; i++) {
      final fv = monotones[i][0].rv;
      final lv = monotones[i][monotones[i].length - 1].rv;

      int offset = 0;
      if (monotones[i].length == 1) {
        if (monotones[i][0].offset > 0) {
          offset = lenestmaxv - lv;
        } else {
          offset = lenestminv - lv;
        }
      } else {
        if (lv > fv) {
          offset = lenestmaxv - lv;
        } else {
          offset = lenestminv - lv;
        }
      }

      final thisOffsets = monotones[i].map((e) => e.offset).toList();
      thisOffsets[0] += offset - previousOffset;

      if (i == 0) {
        thisOffsets[0] -= lenestminv;
      }

      compressed.addAll(thisOffsets);

      previousOffset = offset;
    }

    return compressed;
  }

  /// 高度压缩
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
