import 'package:colorify/backend/abstracts/rgb.dart';

class ParticlePoint {
  double x;
  double y;
  double z;

  String pid;

  RGBA? rgb;

  ParticlePoint({
    required this.x,
    required this.y,
    required this.z,
    required this.pid,
    this.rgb,
  });
}
