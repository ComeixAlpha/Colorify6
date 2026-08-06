class RGBMapping {
  int r;
  int g;
  int b;
  String id;
  RGBMapping({required this.r, required this.g, required this.b, required this.id});

  Map<String, dynamic> toJson() => {'r': r, 'g': g, 'b': b, 'id': id};

  factory RGBMapping.fromJson(Map<String, dynamic> json) => RGBMapping(
    r: json['r'] as int,
    g: json['g'] as int,
    b: json['b'] as int,
    id: json['id'] as String,
  );
}
