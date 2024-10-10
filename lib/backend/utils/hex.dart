  List<int> hexToRgb(String hexColor) {
    if (hexColor.startsWith('#')) {
      hexColor = hexColor.substring(1);
    }

    if (hexColor.length != 6 && hexColor.length != 8) {
      return [];
    }

    int intValue = int.parse(hexColor, radix: 16);

    if (hexColor.length == 6) {
      return [
        (intValue >> 16) & 0xFF,
        (intValue >> 8) & 0xFF,
        intValue & 0xFF,
      ];
    } else {
      return [
        (intValue >> 24) & 0xFF,
        (intValue >> 16) & 0xFF,
        (intValue >> 8) & 0xFF,
        intValue & 0xFF,
      ];
    }
  }