import 'package:basa_app_project/features/cards/domain/entities/time_consume_stats_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:m3e_core/m3e_core.dart';

class CallendarHeatmap extends StatelessWidget {
  const CallendarHeatmap({super.key, required this.dailyData});
  final List<TimeConsumeStatsEntity> dailyData;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      constraints: BoxConstraints(maxHeight: 300),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: GridView.builder(
              itemCount: dailyData.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
              ),
              itemBuilder: (BuildContext context, int dateIndex) {
                return Stack(
                  alignment: AlignmentGeometry.center,
                  children: [
                    M3EShape.flower(
                      color: Theme.of(context).primaryColor.withValues(
                        alpha:
                            (int.parse(dailyData[dateIndex].totalTime.minutes) /
                                dailyData.length) /
                            10,
                      ),
                      width: 40,
                      height: 40,
                    ),
                    Text((dateIndex + 1).toString()),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
