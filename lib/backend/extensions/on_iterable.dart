extension IntIterableExt on Iterable<int> {
  int sum() {
    return reduce((p, q) => p + q);
  }
}

extension DoubleIterableExt on Iterable<double> {
  double sum() {
    return reduce((p, q) => p + q);
  }
}