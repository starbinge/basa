import 'package:basa_app_project/features/cards/domain/entities/time_consume_entity/time_consume_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:m3e_core/m3e_core.dart';

class WeeklyStreakContainer extends StatelessWidget {
  const WeeklyStreakContainer({
    super.key,
    required this.weeklyTimeConsumeData,
    required this.onTapTimeConsumeStats,
  });

  final List<TimeConsumeEntity> weeklyTimeConsumeData;
  final VoidCallback onTapTimeConsumeStats;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxHeight: 131),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 0.5, color: Colors.grey),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            width: double.infinity,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 0.5, color: Colors.grey),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Streaks", style: Theme.of(context).textTheme.titleLarge),
                IconButton(
                  onPressed: onTapTimeConsumeStats,
                  icon: const Icon(Icons.arrow_right_alt_rounded),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: weeklyTimeConsumeData.map((data) {
                  return Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          data.timeLabel,
                          style: const TextStyle(color: Colors.black),
                        ),
                        if (data.avgTime.seconds != 0)
                          M3EShape.c9SidedCookie(
                                width: 35,
                                height: 35,
                                color: Theme.of(context).primaryColorDark,
                              )
                              .animate(
                                onComplete: (controller) => controller.repeat(),
                              )
                              .rotate(
                                curve: Curves.linear,
                                duration: const Duration(seconds: 5),
                              ),
                        if (data.avgTime.seconds == 0)
                          M3EShape.c9SidedCookie(
                            width: 35,
                            height: 35,
                            color: Colors.grey.withValues(alpha: 0.2),
                          ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
