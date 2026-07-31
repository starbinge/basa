import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';

Text getMonthlyTitleByIndexFunction({
  required double axisX,
  required TitleMeta meta,
}) {
  switch (axisX.toInt()) {
    case 1:
      return const Text("J");
    case 2:
      return const Text("F");
    case 3:
      return const Text("M");
    case 4:
      return const Text("A");
    case 5:
      return const Text("M");
    case 6:
      return const Text("J");
    case 7:
      return const Text("J");
    case 8:
      return const Text("A");
    case 9:
      return const Text("S");
    case 10:
      return const Text("O");
    case 11:
      return const Text("N");
    case 12:
      return const Text("D");
    default:
      return const Text("");
  }
}

Text getWeeklyTitleByIndexFunction({
  required double axisX,
  required TitleMeta meta,
}) {
  switch (axisX.toInt()) {
    case 1:
      return const Text("S");
    case 2:
      return const Text("M");
    case 3:
      return const Text("T");
    case 4:
      return const Text("W");
    case 5:
      return const Text("T");
    case 6:
      return const Text("F");
    case 7:
      return const Text("S");

    default:
      return const Text("");
  }
}
