import 'package:flutter/material.dart';

sealed class OldTheme {
  static const background = Color(0xFF26232a);
  static const card = Color(0xFF2d2a31);
}

sealed class MyTheme {
  static const background = Color(0xff161217);
  static const primary = Color(0xff290a36);
  static const onPrimary = Color(0xfff0bffa);
  static const card = Color(0xff221e24);
  static const outline = Color(0xff302c40);
  static const outlineHighlight = Color(0xffa995c9);
  static const button = Color(0xff5d4e62);
  static const buttonHover = Color.fromARGB(255, 121, 103, 126);
  static const onButton = Color(0xfff0dcf4);
  static const checkBoxCheckColor = Color(0xff432255);
  static const checkBoxActiveColor = Color(0xffe2b7f5);
  static const tertiary = Color(0xfffe949c);
  static const onTertiary = Color(0xff5e000f);
}
