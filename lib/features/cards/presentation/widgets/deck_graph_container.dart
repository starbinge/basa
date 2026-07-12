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
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: _data.asMap().entries.map((entry) {
            int dataIndex = entry.key;
            DeckAccuracy deck = entry.value;
            return BarChartGroupData(
              x: dataIndex + 1,
              barRods: [
                BarChartRodData(
                  color: _getBarColor(deck.accuracyNumber.toDouble()),
                  width: context.screenWidth * 0.07,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  toY: deck.accuracyNumber.toDouble(),
                ),
              ],
            );
          }).toList(),
          titlesData: FlTitlesData(
            show: true,
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
