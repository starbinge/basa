import 'package:basa_app_project/features/cards/domain/usecases/get_sidetitles_chart_usecase.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

TitleMeta buildMeta() {
  return TitleMeta(
    min: 0,
    max: 10,
    parentAxisSize: 100,
    axisPosition: 0,
    appliedInterval: 1,
    sideTitles: const SideTitles(showTitles: true),
    formattedValue: '1',
    axisSide: AxisSide.bottom,
    rotationQuarterTurns: 0,
  );
}

void main() {
  group('getMonthlyTitleByIndexFunction', () {
    const Map<int, String> expected = {
      1: 'J',
      2: 'F',
      3: 'M',
      4: 'A',
      5: 'M',
      6: 'J',
      7: 'J',
      8: 'A',
      9: 'S',
      10: 'O',
      11: 'N',
      12: 'D',
    };

    test('maps month indices to their initial letter', () {
      expected.forEach((index, initial) {
        final Text text = getMonthlyTitleByIndexFunction(
          axisX: index.toDouble(),
          meta: buildMeta(),
        );
        expect(text.data, initial);
      });
    });

    test('returns empty text for unknown indices', () {
      for (final double index in [0, 13, -1, 100]) {
        final Text text = getMonthlyTitleByIndexFunction(
          axisX: index,
          meta: buildMeta(),
        );
        expect(text.data, '');
      }
    });
  });

  group('getWeeklyTitleByIndexFunction', () {
    const Map<int, String> expected = {
      1: 'S',
      2: 'M',
      3: 'T',
      4: 'W',
      5: 'T',
      6: 'F',
      7: 'S',
    };

    test('maps day indices to their initial letter', () {
      expected.forEach((index, initial) {
        final Text text = getWeeklyTitleByIndexFunction(
          axisX: index.toDouble(),
          meta: buildMeta(),
        );
        expect(text.data, initial);
      });
    });

    test('returns empty text for unknown indices', () {
      for (final double index in [0, 8, -2]) {
        final Text text = getWeeklyTitleByIndexFunction(
          axisX: index,
          meta: buildMeta(),
        );
        expect(text.data, '');
      }
    });
  });
}
