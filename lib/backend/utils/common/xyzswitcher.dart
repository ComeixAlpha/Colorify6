/// X(Y=0)Z Switcher
List<T> xzswitcher<T>(int plane, List<T> xyz) {
  if (plane == 0) {
    return xyz;
  } else if (plane == 1) {
    return [xyz[0], xyz[2], xyz[1]];
  } else if (plane == 2) {
    return [xyz[1], xyz[0], xyz[2]];
  } else {
    throw Exception();
  }
}

/// XY(Z=0) Switcher
List<T> xyswitcher<T>(int plane, List<T> xyz) {
  if (plane == 0) {
    return [xyz[0], xyz[2], xyz[1]];
  } else if (plane == 1) {
    return xyz;
  } else if (plane == 2) {
    return [xyz[1], xyz[0], xyz[2]];
  } else {
    throw Exception();
  }
}
