import 'package:basa_app_project/core/widgets/animated_header.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';
import 'package:basa_app_project/features/cards/domain/entities/time_consume_entity/time_consume_entity.dart';
import 'package:basa_app_project/features/cards/presentation/widgets/statistics/shared/stats_number_container.dart';
import 'package:basa_app_project/features/cards/presentation/widgets/statistics/shared/stats_vocab_container.dart';
import 'package:flutter/material.dart';
import 'package:m3e_core/m3e_core.dart';

class BottomSheetStats extends StatelessWidget {
  final bool isLoading;
  final bool isFutureDate;
  final bool isEmpty;
  final int date;
  final String monthName;
  final String title;
  final List<CardsDetailEntity> listCards;
  final String avgStatValue;
  final String avgStatLabel;
  final int totalCards;
  final TimeUnit totalTime;

  const BottomSheetStats({
    super.key,
    required this.isLoading,
    required this.isFutureDate,
    required this.isEmpty,
    required this.date,
    required this.monthName,
    required this.title,
    this.listCards = const [],
    this.avgStatValue = '',
    this.avgStatLabel = 'Avg',
    this.totalCards = 0,
    this.totalTime = const TimeUnit(hour: 0, minute: 0, seconds: 0),
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (isEmpty) {
      return Center(
        child: Container(
          color: Colors.white,
          child: AnimatedHeader(
            size: 120,
            icon: isFutureDate ? Icons.question_mark : Icons.warning,
            title: isFutureDate
                ? "I don't think we have already knew each other at this day"
                : "Be patient, kid.",
            subtitle: isFutureDate
                ? "You should be faster to come here, tho."
                : "Today is still not the day",
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            AnimatedHeader(
              size: 90,
              icon: Icons.stacked_bar_chart_rounded,
              title: "$date of $monthName",
              subtitle: "Summary Stats for Selected Date",
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StatsNumberContainer(number: '$totalCards', numberLabel: 'Cards'),
                StatsNumberContainer(number: avgStatValue, numberLabel: avgStatLabel),
                StatsNumberContainer(number: totalTime.formatted, numberLabel: 'Active'),
              ],
            ),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.grey.shade600),
            ),
            ...listCards.map((data) {
              return StatsVocabContainer(
                title: title,
                translatedLanguage: data.translatedLanguage,
                defaultLanguage: data.defaultLanguage,
                numberIndicator: avgStatValue,
              );
            }).toList(),
            M3EButton(
              size: M3EButtonSize.custom(width: double.infinity),
              onPressed: () => Navigator.pop(context),
              child: const Text("Okay"),
            ),
          ],
        ),
      ),
    );
  }
}
