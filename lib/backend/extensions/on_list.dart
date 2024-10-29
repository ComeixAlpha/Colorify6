extension ListExt<T> on List<T> {
  void enumerate(dynamic Function(int, T) fn) {
    for (int i = 0; i < length; i++) {
      fn(i, this[i]);
    }
  }

  Future<void> enumerateAsync(Future<dynamic> Function(int, T) fn) async {
    for (int i = 0; i < length; i++) {
      await fn(i, this[i]);
    }
  }

  List<T> mapInEnumerate(T Function(int, T) fn) {
    for (int i = 0; i < length; i++) {
      this[i] = fn(i, this[i]);
    }
    return this;
  }
}

extension NumListExt on List<int> {
  int max() {
    if (length == 0) {
      throw Exception();
    }
    int maxv = this[0];
    for (int v in this) {
      if (v > maxv) {
        maxv = v;
      }
    }
    return maxv;
  }
}
