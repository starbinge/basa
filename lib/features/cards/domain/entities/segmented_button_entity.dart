import 'package:flutter/material.dart';

class ColorPreference {
  final Color selectedColor;
  final Color unselectedColor;

  ColorPreference({required this.selectedColor, required this.unselectedColor});
}

class SegmentedButtonEntity {
  final VoidCallback onTap;

  final ColorPreference backgroundColor;
  final ColorPreference foregroundColor;
  final String text;
  final bool selectionParamter;
  final double borderRadiusSize;

  SegmentedButtonEntity({
    required this.onTap,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.text,
    required this.selectionParamter,
    required this.borderRadiusSize,
  });
}
