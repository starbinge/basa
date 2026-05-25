import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.title,
    required this.action,
    this.style,
  });

  final String title;
  final VoidCallback action;
  final ButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: action, child: Text(title), style: style);
  }
}
