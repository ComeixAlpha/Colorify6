import 'dart:math';

import 'package:colorify/backend/utils/common/math.dart';

MVector3 rotate(MVector3 vec, MVector3 fitV) {
  if (fitV.x == 0) {
    fitV.x = 0.001;
  }
  if (fitV.y == 0) {
    fitV.y = 0.001;
  }
  if (fitV.z == 0) {
    fitV.z = 0.001;
  }

  final nnv = MVector3(0, 1, 0);
  final nfitV = fitV.normalize();

  final axis = nnv.cross(nfitV);
  final naxis = axis.normalize();

  final dotProduct = nnv.dot(nfitV);
  final angle = acos(dotProduct);

  final mat = Matrix3(0, 0, 0, 0, 0, 0, 0, 0, 0);
  final rotMat = mat.rotateByAxis(angle, naxis);

  final res = rotMat.multiplyWithVector3(vec);
  return res;
}
