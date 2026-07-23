import 'package:flutter/material.dart';

class AnimatedPlayPauseButton extends StatelessWidget {
  const AnimatedPlayPauseButton({
    super.key,
    required this.isPlaying,
    required this.onPressed,
    this.size = 24.0,
    this.color,
    this.backgroundColor,
    this.padding,
  });

  final bool isPlaying;
  final VoidCallback onPressed;
  final double size;
  final Color? color;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Theme.of(context).primaryColor;

    return IconButton(
      padding: padding,
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(backgroundColor),
      ),
      onPressed: onPressed,
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return ScaleTransition(
            scale: animation,
            child: RotationTransition(
              turns: Tween<double>(begin: 0.5, end: 1.0).animate(animation),
              child: child,
            ),
          );
        },
        child: Icon(
          isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
          key: ValueKey<bool>(isPlaying),
          size: size,
          color: effectiveColor,
        ),
      ),
    );
  }
}
