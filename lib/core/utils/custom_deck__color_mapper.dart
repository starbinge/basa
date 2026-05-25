import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomDeckColorMapper extends ColorMapper {
  final int selectedColor;

  CustomDeckColorMapper({required this.selectedColor});

  @override
  Color substitute(
    String? id,
    String elementName,
    String attributeName,
    Color color,
  ) {
    return switch (color) {
      const Color(0xFFD9D9D9) => Color(selectedColor),
      const Color(0xFF737373) => Color.alphaBlend(
        Colors.black.withAlpha(120),
        Color(selectedColor),
      ),
      const Color(0xFF929191) => Color.alphaBlend(
        Colors.black.withAlpha(120),
        Color(selectedColor),
      ),
      const Color(0xFF525252) => Color.alphaBlend(
        Colors.black.withAlpha(230),
        Color(selectedColor),
      ),
      const Color(0xFF737373) => Color.alphaBlend(
        Colors.black.withAlpha(130),
        Color(selectedColor),
      ),
      const Color(0xFF8B8B8B) => Color.alphaBlend(
        Colors.black.withAlpha(90),
        Color(selectedColor),
      ),
      _ => color,
    };
  }
}
