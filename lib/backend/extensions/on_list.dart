extension ListExt<T> on List<T> {
  void enumerate(Function(int, T) fn) {
    for (int i = 0; i < length; i++) {
      fn(i, this[i]);
    }
  }

  Future<void> enumerateAsync(Future<dynamic> Function(int, T) fn) async {
    for (int i = 0; i < length; i++) {
      await fn(i, this[i]);
    }
  }

  bool everyInEnumerate(bool Function(int, T) fn) {
    for (int i = 0; i < length; i++) {
      if (!fn(i, this[i])) {
        return false;
      }
    }
    return true;
  }

  List<T> mapInEnumerate(T Function(int, T) fn) {
    for (int i = 0; i < length; i++) {
      this[i] = fn(i, this[i]);
    }
    return this;
  }
}
