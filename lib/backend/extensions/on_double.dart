

extension DoubleExt on double {

  String toPercentString() {
    return '${(this * 100).toStringAsFixed(2)}%';
  }
}
