import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/constants/screen_size.dart';

class DeckGraphContainer<T> extends StatelessWidget {
  const DeckGraphContainer({
    super.key,
    required List<T> data,
    required GetTitleWidgetFunction getTitlesWidget,
    required this.getYValue,
    this.maxY,
    required this.onBarTap,
  }) : _getTitlesWidget = getTitlesWidget,
       _data = data;

  final List<T> _data;
  final GetTitleWidgetFunction _getTitlesWidget;
  final double Function(T item) getYValue;
  final double? maxY;
  final void Function(int barIndex) onBarTap;

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
      constraints: BoxConstraints(minHeight: 200.h, maxHeight: 280.h),
      padding: EdgeInsetsGeometry.all(15),
      width: double.infinity,
      child: BarChart(
        BarChartData(
          barTouchData: BarTouchData(
            touchCallback:
                (FlTouchEvent event, BarTouchResponse? touchResponse) {
                  if (event is! FlTapUpEvent ||
                      touchResponse == null ||
                      touchResponse.spot == null) {
                    return;
                  }
                  onBarTap(touchResponse.spot!.touchedBarGroupIndex + 1);
                },
          ),
          minY: 0,
          maxY:
              maxY ??
              (_data.isEmpty
                  ? 100.0
                  : (_data.map(getYValue).reduce((a, b) => a > b ? a : b)) + 2),
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
            T item = entry.value;
            double yValue = getYValue(item);
            return BarChartGroupData(
              x: dataIndex + 1,
              barRods: [
                BarChartRodData(
                  color: _getBarColor(yValue),
                  width: context.screenWidth * 0.09,
                  borderRadius: BorderRadius.circular(20),
                  toY: yValue,
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
