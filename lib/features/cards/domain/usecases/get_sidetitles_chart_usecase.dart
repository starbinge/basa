import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';

Text getMonthlyTitleByIndexFunction({
  required double axisX,
  required TitleMeta meta,
}) {
  switch (axisX.toInt()) {
    case 1:
      return Text("J");
    case 2:
      return Text("F");
    case 3:
      return Text("M");
    case 4:
      return Text("A");
    case 5:
      return Text("M");
    case 6:
      return Text("J");
    case 7:
      return Text("J");
    case 8:
      return Text("A");
    case 9:
      return Text("S");
    case 10:
      return Text("O");
    case 11:
      return Text("N");
    case 12:
      return Text("D");
    default:
      return Text("");
  }
}

Text getWeeklyTitleByIndexFunction({
  required double axisX,
  required TitleMeta meta,
}) {
  switch (axisX.toInt()) {
    case 1:
      return Text("S");
    case 2:
      return Text("M");
    case 3:
      return Text("T");
    case 4:
      return Text("W");
    case 5:
      return Text("T");
    case 6:
      return Text("F");
    case 7:
      return Text("S");

    default:
      return Text("");
  }
}
