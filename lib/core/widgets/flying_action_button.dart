import 'package:flutter/material.dart';

class FlyingActionButton extends StatelessWidget {
  const FlyingActionButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(child: Icon(icon), onPressed: onTap);
  }
}
