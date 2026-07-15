import 'package:basa_app_project/features/cards/data/models/flashcard_statistic_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/screen_size.dart';

class DeckGraphContainer extends StatelessWidget {
  const DeckGraphContainer({
    super.key,
    required List<DeckAccuracy> data,
    required GetTitleWidgetFunction getTitlesWidget,
  }) : _getTitlesWidget = getTitlesWidget,
       _data = data;

  final List<DeckAccuracy> _data;
  final GetTitleWidgetFunction _getTitlesWidget;

  @override
  Widget build(BuildContext context) {
    Color _getBarColor(double accuracy) {
      if (accuracy < 50) {
        return Theme.of(context).colorScheme.error;
      } else if (accuracy < 80) {
        return Colors.orange;
      } else {
        return Theme.of(context).primaryColor;
      }
    }

    return Container(
      constraints: BoxConstraints(minHeight: 200.h, maxHeight: 450.h),
      padding: EdgeInsetsGeometry.all(15),
      width: double.infinity,
      child: BarChart(
        BarChartData(
          minY: 0,
          maxY: 100,
          alignment: BarChartAlignment.spaceAround,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.shade300,
                strokeWidth: 2,
                dashArray: [5, 5],
              );
            },
          ),
          borderData: FlBorderData(show: false),
          barGroups: _data.asMap().entries.map((entry) {
            int dataIndex = entry.key;
            DeckAccuracy deck = entry.value;
            return BarChartGroupData(
              x: dataIndex + 1,
              barRods: [
                BarChartRodData(
                  color: _getBarColor(deck.accuracyNumber.toDouble()),
                  width: context.screenWidth * 0.09,
                  borderRadius: BorderRadius.circular(20),
                  toY: deck.accuracyNumber.toDouble(),
                ),
              ],
            );
          }).toList(),
          titlesData: FlTitlesData(
            show: true,

            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  );
                },
              ),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(reservedSize: 30, showTitles: false),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitleAlignment: SideTitleAlignment.outside,
              sideTitles: SideTitles(
                reservedSize: 30,
                showTitles: true,
                getTitlesWidget: _getTitlesWidget,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
