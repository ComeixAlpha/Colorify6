// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:math';

class Vector3 {
  late double x;
  late double y;
  late double z;
  late double length;

  Vector3(this.x, this.y, this.z) {
    length = sqrt(pow(x, 2) + pow(y, 2) + pow(z, 2));
  }

  Vector3 plus(Vector3 vec) {
    return Vector3(x + vec.x, y + vec.y, z + vec.z);
  }

  Vector3 substract(Vector3 vec) {
    return Vector3(x - vec.x, y - vec.y, z - vec.z);
  }

  Vector3 times(num n) {
    return Vector3(x * n, y * n, z * n);
  }

  Vector3 divides(num n) {
    return Vector3(x / n, y / n, z / n);
  }

  double dot(Vector3 vec) {
    return x * vec.x + y * vec.y + z * vec.z;
  }

  Vector3 cross(Vector3 vec) {
    return Vector3(
      y * vec.z - vec.y * z,
      vec.x * z - vec.z * x,
      x * vec.y - vec.x * y,
    );
  }

  Vector3 normalize() {
    return Vector3(x / length, y / length, z / length);
  }

  Vector3 clone() {
    return Vector3(x, y, z);
  }

  Vector3 negate() {
    return Vector3(-x, -y, -z);
  }
}

class Matrix3 {
  late double n11;
  late double n12;
  late double n13;
  late double n21;
  late double n22;
  late double n23;
  late double n31;
  late double n32;
  late double n33;

  Matrix3(
    this.n11,
    this.n12,
    this.n13,
    this.n21,
    this.n22,
    this.n23,
    this.n31,
    this.n32,
    this.n33,
  );

  Vector3 multiplyWithVector3(Vector3 vec) {
    final x = vec.x;
    final y = vec.y;
    final z = vec.z;
    return Vector3(
      n11 * x + n12 * y + n13 * z,
      n21 * x + n22 * y + n23 * z,
      n31 * x + n32 * y + n33 * z,
    );
  }

  Matrix3 rotateByAxis(num angle, Vector3 axis) {
    final c = cos(angle);
    final s = sin(angle);
    final omc = 1 - c;
    final x = axis.x;
    final y = axis.y;
    final z = axis.z;

    final _n11 = c + x * x * omc;
    final _n12 = x * y * omc - z * s;
    final _n13 = x * z * omc + y * s;

    final _n21 = y * x * omc + z * s;
    final _n22 = c + y * y * omc;
    final _n23 = y * z * omc - x * s;

    final _n31 = z * x * omc - y * s;
    final _n32 = z * y * omc + x * s;
    final _n33 = c + z * z * omc;

    return Matrix3(_n11, _n12, _n13, _n21, _n22, _n23, _n31, _n32, _n33);
  }
}
