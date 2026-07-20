import 'package:basa_app_project/features/cards/data/models/flashcard_statistic_model.dart';
import 'package:basa_app_project/features/cards/presentation/widgets/accuracy_stats_header.dart';
import 'package:basa_app_project/features/cards/presentation/widgets/weekly_streak_container.dart';
import 'package:flutter/material.dart';

class CardStats extends StatelessWidget {
  const CardStats({
    super.key,
    required this.onTapAccuracyStats,
    required this.onTapTimeConsumeStats,
    required this.thisMonthAccuracyStats,
    required this.previousMonthAccuracyStats,
    required this.weeklyTimeConsumeData,
  });

  final VoidCallback onTapAccuracyStats;
  final VoidCallback onTapTimeConsumeStats;
  final int thisMonthAccuracyStats;
  final int previousMonthAccuracyStats;
  final List<DeckTimeConsume> weeklyTimeConsumeData;
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        color: Theme.of(context).canvasColor,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: onTapTimeConsumeStats,
              child: WeeklyStreakContainer(
                weeklyTimeConsumeData: weeklyTimeConsumeData,
                onTapTimeConsumeStats: onTapTimeConsumeStats,
              ),
            ),
            GestureDetector(
              onTap: onTapAccuracyStats,
              child: AccuracyStatsHeader(
                thisMonthStats: thisMonthAccuracyStats,
                previousMonthStats: previousMonthAccuracyStats,
              ),
            ),

            Text(
              "Keep tracking the progress will help you to boost your language skills",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
