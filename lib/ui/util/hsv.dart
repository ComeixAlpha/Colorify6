import 'dart:math';

import 'package:flutter/material.dart';

class HSV {
  double hue;
  double saturation;
  double value;

  HSV(this.hue, this.saturation, this.value);

  Color toColor() {
    double c = value * saturation;
    double x = c * (1 - ((hue / 60) % 2 - 1).abs());
    double m = value - c;

    double r = 0, g = 0, b = 0;

    if (hue >= 0 && hue < 60) {
      r = c;
      g = x;
    } else if (hue >= 60 && hue < 120) {
      r = x;
      g = c;
    } else if (hue >= 120 && hue < 180) {
      g = c;
      b = x;
    } else if (hue >= 180 && hue < 240) {
      g = x;
      b = c;
    } else if (hue >= 240 && hue < 300) {
      r = x;
      b = c;
    } else if (hue >= 300 && hue < 360) {
      r = c;
      b = x;
    }

    r = (r + m) * 255;
    g = (g + m) * 255;
    b = (b + m) * 255;

    return Color.fromARGB(255, r.round(), g.round(), b.round());
  }

  static HSV fromColor(Color color) {
    double r = color.r;
    double g = color.g;
    double b = color.b;

    double maxVal = max(r, max(g, b));
    double minVal = min(r, min(g, b));
    double delta = maxVal - minVal;

    double hue = 0;
    if (delta != 0) {
      if (maxVal == r) {
        hue = 60 * (((g - b) / delta) % 6);
      } else if (maxVal == g) {
        hue = 60 * (((b - r) / delta) + 2);
      } else {
        hue = 60 * (((r - g) / delta) + 4);
      }
    }

    double saturation = maxVal == 0 ? 0 : delta / maxVal;
    double value = maxVal;

    if (hue < 0) {
      hue += 360;
    }

    return HSV(hue, saturation, value);
  }
}