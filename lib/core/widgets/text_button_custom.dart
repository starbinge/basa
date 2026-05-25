import 'package:flutter/material.dart';

class TextButtonCustom extends StatelessWidget {
  const TextButtonCustom({
    super.key,
    required this.theme,
    this.buttonStyle,
    this.placeHolder,
    this.onPressedButton,
  });

  final ThemeData theme;
  final ButtonStyle? buttonStyle;
  final String? placeHolder;
  final VoidCallback? onPressedButton;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: buttonStyle ??
          ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(theme.colorScheme.primary),
            foregroundColor: WidgetStatePropertyAll(
              theme.colorScheme.onSurfaceVariant.withAlpha(120),
            ),
          ),
      onPressed: onPressedButton,
      child: Text(placeHolder ?? "Next"),
    );
  }
}
