import 'package:basa_app_project/core/widgets/callendar_heatmap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'onDateTap reports the date using the provided year and month',
    (tester) async {
      DateTime? tappedDate;
      final key = GlobalKey();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 300,
              width: 300,
              child: CallendarHeatmap(
                key: key,
                itemCount: 31,
                year: 2026,
                month: 8,
                getValue: (_) => 0.0,
                onDateTap: (date) => tappedDate = date,
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.descendant(
        of: find.byKey(key),
        matching: find.text('15'),
      ));

      expect(tappedDate, DateTime(2026, 8, 15));
    },
  );

  testWidgets(
    'onDateTap defaults to the current year and month',
    (tester) async {
      final now = DateTime.now();
      DateTime? tappedDate;
      final key = GlobalKey();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 300,
              width: 300,
              child: CallendarHeatmap(
                key: key,
                itemCount: 31,
                getValue: (_) => 0.0,
                onDateTap: (date) => tappedDate = date,
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.descendant(
        of: find.byKey(key),
        matching: find.text('5'),
      ));

      expect(tappedDate, DateTime(now.year, now.month, 5));
    },
  );
}
