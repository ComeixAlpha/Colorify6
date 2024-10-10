import 'package:flutter/material.dart';

TextStyle getStyle({
  double? size,
  Color? color,
  FontWeight weight = FontWeight.normal,
  String? fontFamily = 'Poppins',
  TextDecoration? decoration = TextDecoration.none,
  TextDecorationStyle? decorationStyle,
}) {
  return TextStyle(
    color: color,
    fontFamily: fontFamily,
    fontSize: size,
    fontWeight: weight,
    decoration: decoration,
    decorationStyle: decorationStyle,
    fontFamilyFallback: const ['Noto Serif SC'],
  );
}
