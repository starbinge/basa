import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:m3e_core/m3e_core.dart';

class AnimatedHeader extends StatelessWidget {
  const AnimatedHeader({
    super.key,
    required this.icon,
    this.title = "No activity yet",
    this.subtitle = "Start studying to see your progress!",
    this.size = 50,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: AlignmentGeometry.center,
            children: [
              M3EShape.c9SidedCookie(
                    width: size,
                    height: size,
                    color: Theme.of(context).primaryColorDark,
                  )
                  .animate(onComplete: (controller) => controller.repeat())
                  .rotate(duration: const Duration(seconds: 5), curve: Curves.linear),
              Icon(icon, size: size! / 2, color: Colors.white),
            ],
          ),

          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),

          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
