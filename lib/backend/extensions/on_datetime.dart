extension DateTimeExt on DateTime {
  String display() {
    return '$year-$month-$day $hour:$minute:$second';
  }

  String hmsOnly() {
    return '$hour:$minute:$second';
  }
}
