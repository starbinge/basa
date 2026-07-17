import 'package:flutter/material.dart';

import '../../../../core/widgets/stats_card.dart';

class CardStats extends StatelessWidget {
  const CardStats({
    super.key,
    required this.onTapAccuracyStats,
    required this.onTapTimeConsumeStats,
  });

  final VoidCallback onTapAccuracyStats;
  final VoidCallback onTapTimeConsumeStats;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        color: Theme.of(context).canvasColor,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              children: [
                GestureDetector(
                  onTap: onTapAccuracyStats,
                  child: StatsCard(
                    colorCards: Theme.of(context).colorScheme.secondary,
                    statsNumber: 20,
                    statsTitle: 'Accuracy',
                    statsIcon: Icons.polyline_outlined,
                  ),
                ),
                GestureDetector(
                  onTap: onTapTimeConsumeStats,
                  child: StatsCard(
                    colorCards: Theme.of(context).colorScheme.primary,
                    statsNumber: 20,
                    statsTitle: 'Play Time',
                    statsIcon: Icons.timer_outlined,
                  ),
                ),
              ],
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
