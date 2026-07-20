import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:m3e_core/m3e_core.dart';

class StatsEmptyState extends StatelessWidget {
  const StatsEmptyState({
    super.key,
    required this.icon,
    this.title = "No activity yet",
    this.subtitle = "Start studying to see your progress!",
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: AlignmentGeometry.center,
            children: [
              M3EShape.c9SidedCookie(
                    width: 100,
                    height: 100,
                    color: Theme.of(context).primaryColorDark,
                  )
                  .animate(onComplete: (controller) => controller.repeat())
                  .rotate(
                    duration: Duration(seconds: 5),
                    curve: Curves.linear,
                  ),
              Icon(icon, size: 50, color: Colors.white),
            ],
          ),
          SizedBox(height: 20),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 8),
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
