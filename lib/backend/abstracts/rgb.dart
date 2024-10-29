class RGBA {
  int r;
  int g;
  int b;
  int a;
  RGBA({
    required this.r,
    required this.g,
    required this.b,
    required this.a,
  });

  static RGBA fromRGBList(List<int> v) {
    return RGBA(
      r: v[0],
      g: v[1],
      b: v[2],
      a: 0,
    );
  }

  @override
  String toString() {
    return '[$r, $g, $b, $a]';
  }
}

class RGBAMat {}
