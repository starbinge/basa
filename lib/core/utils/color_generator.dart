import 'dart:math';
import 'package:flutter/material.dart';

Color get randomPastelColor {
  final random = Random();
  final hue = random.nextDouble() * 360; // 0–360
  const saturation = 0.5;
  const lightness = 0.3;
  return HSLColor.fromAHSL(1.0, hue, saturation, lightness).toColor();
}
