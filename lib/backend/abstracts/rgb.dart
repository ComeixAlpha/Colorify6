class RGBA {
  int r;
  int g;
  int b;
  int a;
  RGBA({
    required this.r,
    required this.g,
    required this.b,
    this.a = 0,
  });

  static RGBA fromRGBList(List<int> v) {
    return RGBA(
      r: v[0].clamp(0, 255),
      g: v[1].clamp(0, 255),
      b: v[2].clamp(0, 255),
      a: 0,
    );
  }

  @override
  String toString() {
    return '[$r, $g, $b, $a]';
  }
}
