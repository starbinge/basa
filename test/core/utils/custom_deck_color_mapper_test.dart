import 'package:basa_app_project/core/utils/custom_deck__color_mapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const int selectedColor = 0xFF2196F3;
  final mapper = CustomDeckColorMapper(selectedColor: selectedColor);

  Color substitute(Color color) =>
      mapper.substitute(null, 'path', 'fill', color);

  group('CustomDeckColorMapper', () {
    test('maps the folder body color to the selected color', () {
      expect(substitute(const Color(0xFFBEBEBE)), const Color(selectedColor));
    });

    test('maps the light folder color to the selected color', () {
      expect(substitute(const Color(0xFFD9D9D9)), const Color(selectedColor));
    });

    test('maps the glyph color to a darker blend of the selected color', () {
      expect(
        substitute(const Color(0xFF8B8B8B)),
        Color.alphaBlend(Colors.black.withAlpha(90), const Color(selectedColor)),
      );
    });

    test('maps the darkest folder color to a very dark blend', () {
      expect(
        substitute(const Color(0xFF525252)),
        Color.alphaBlend(
          Colors.black.withAlpha(230),
          const Color(selectedColor),
        ),
      );
    });

    test('keeps unknown colors unchanged', () {
      const unknown = Color(0xFF123456);
      expect(substitute(unknown), unknown);
    });
  });
}
