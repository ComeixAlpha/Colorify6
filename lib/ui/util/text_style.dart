import 'package:flutter/material.dart';

TextStyle getStyle({
  double? size,
  Color? color,
  FontWeight weight = FontWeight.normal,
  FontStyle? fontStyle = FontStyle.normal,
  String? fontFamily = 'Poppins',
  TextDecoration? decoration = TextDecoration.none,
  TextDecorationStyle? decorationStyle,
}) {
  return TextStyle(
    color: color,
    fontFamily: fontFamily,
    fontSize: size,
    fontWeight: weight,
    fontStyle: fontStyle,
    decoration: decoration,
    decorationColor: color,
    decorationStyle: decorationStyle,
    fontFamilyFallback: const ['Noto Serif SC'],
  );
}
