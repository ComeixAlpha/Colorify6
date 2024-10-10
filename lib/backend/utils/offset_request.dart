/// Records offset request from previous block(north one)
class OffsetRequest {
  // North block y pos
  int basey;
  int offset;
  OffsetRequest({
    required this.basey,
    required this.offset,
  });
}

/// Matrix consists of OffsetRequest(s)
/// Initialize as empty(invalid offset request filled)
class OffsetRequestMatrix {
  late final int width;
  late final int height;
  late final List<List<OffsetRequest>> orm;
  OffsetRequestMatrix({required this.width, required this.height}) {
    orm = List.generate(
      width,
      (_) => List.generate(
        height,
        (_) => OffsetRequest(basey: -132, offset: -132),
      ),
    );
  }

  OffsetRequest? getor(int x, int z) {
    if (x >= orm.length) return null;
    if (z >= orm[x].length) return null;
    return orm[x][z];
  }

  void update(int x, int z, OffsetRequest or) {
    if (x >= width || z >= height) {
      return;
    }
    orm[x][z] = or;
  }
}
