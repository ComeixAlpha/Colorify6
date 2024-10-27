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

  @override
  String toString() {
    return '[$r, $g, $b, $a]';
  }
}

class RGBAMat {}
