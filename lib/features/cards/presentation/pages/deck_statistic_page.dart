import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:basa_app_project/core/pages/error_page.dart';
import 'package:basa_app_project/core/widgets/stats_empty_state.dart';
import 'package:basa_app_project/features/cards/constants/enums/statistics_page_enum.dart';
import 'package:basa_app_project/features/cards/data/models/flashcard_statistic_model.dart';
import 'package:basa_app_project/features/cards/presentation/bloc/statistics/card_accuracy/card_accuracy_bloc.dart';
import 'package:basa_app_project/features/cards/presentation/bloc/statistics/time_consume/time_consume_bloc.dart';
import 'package:basa_app_project/features/cards/presentation/widgets/layouts/accuracy_stats_layout.dart';
import 'package:basa_app_project/features/cards/presentation/widgets/layouts/play_time_stats_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeckStatisticPage extends StatefulWidget {
  const DeckStatisticPage({
    super.key,
    required this.deckName,
    required this.statsType,
    required this.filePath,
  });

  final String deckName;
  final StatisticsPageEnum statsType;
  final File filePath;

  @override
  State<DeckStatisticPage> createState() => _DeckStatisticPageState();
}

class _DeckStatisticPageState extends State<DeckStatisticPage> {
  bool _isAudioPlated = false;
  AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Statistics"),
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
      ),
      body: widget.statsType == StatisticsPageEnum.accuracy
          ? BlocBuilder<CardAccuracyBloc, CardAccuracyState>(
              builder: (context, state) {
                if (state is CardAccuracyLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                if (state is CardAccuracyError) {
                  return ErrorPage(message: state.errorMessage);
                }
                if (state is AccuracyDetailLoaded) {
                  final bool isEmpty =
                      state.dailyAccuracy.isEmpty &&
                      state.weeklyAccuracy.isEmpty &&
                      state.monthlyAccuracy.isEmpty &&
                      state.top3TodayMostAccurate.isEmpty &&
                      state.top3TodayLeastAccurate.isEmpty &&
                      state.top3WeeklyMostAccurate.isEmpty &&
                      state.top3WeeklyLeastAccurate.isEmpty &&
                      state.top3MonthlyMostAccurate.isEmpty &&
                      state.top3MonthlyLeastAccurate.isEmpty;
                  if (isEmpty) {
                    return SafeArea(
                      child: StatsEmptyState(
                        icon: Icons.bar_chart_rounded,
                      ),
                    );
                  }
                  return SafeArea(
                    child: CustomScrollView(
                      physics: BouncingScrollPhysics(),
                      slivers: [
                        AccuracyStatsLayout(
                          stats: DeckAccuracyStats(
                            thisMonthDeckAccuracy: state.thisMonthAccuracy,
                            previousMonthDeckAccuracy: state.previousMonthAccuracy,
                            weeklyList: state.weeklyAccuracy,
                            monthlyList: state.monthlyAccuracy,
                            dailyAccuracyList: state.dailyAccuracy,
                            top3TodayMostAccurate: state.top3TodayMostAccurate,
                            top3TodayLeastAccurate: state.top3TodayLeastAccurate,
                            top3WeeklyMostAccurate: state.top3WeeklyMostAccurate,
                            top3WeeklyLeastAccurate: state.top3WeeklyLeastAccurate,
                            top3MonthlyMostAccurate: state.top3MonthlyMostAccurate,
                            top3MonthlyLeastAccurate: state.top3MonthlyLeastAccurate,
                          ),
                          isAudioPlayed: _isAudioPlated,
                          audioPlayer: _audioPlayer,
                          filePath: widget.filePath,
                        ),
                      ],
                    ),
                  );
                }
                return ErrorPage();
              },
            )
          : BlocBuilder<TimeConsumeBloc, TimeConsumeState>(
              builder: (context, state) {
                if (state is TimeConsumeLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                if (state is TimeConsumeError) {
                  return ErrorPage(message: state.errorMessage);
                }
                if (state is TimeConsumeDetailLoaded) {
                  final bool isEmpty =
                      state.dailyTimeConsume.isEmpty &&
                      state.weeklyTimeConsume.isEmpty &&
                      state.monthlyTimeConsume.isEmpty &&
                      state.top3TodayMostTimeConsume.every((c) => c.id == 0) &&
                      state.top3WeeklyMostTimeConsume.every((c) => c.id == 0) &&
                      state.top3MonthlyMostTimeConsume.every((c) => c.id == 0) &&
                      state.top3TodayLeastTimeConsume.every((c) => c.id == 0) &&
                      state.top3WeeklyLeastTimeConsume.every((c) => c.id == 0) &&
                      state.top3MonthlyLeastTimeConsume.every((c) => c.id == 0);
                  if (isEmpty) {
                    return SafeArea(
                      child: StatsEmptyState(
                        icon: Icons.timer_outlined,
                      ),
                    );
                  }
                  return SafeArea(
                    child: CustomScrollView(
                      physics: BouncingScrollPhysics(),
                      slivers: [
                        PlayTimeStatsLayout(
                          timeStats: state.thisMonthTimeConsume,
                          monthlyData: state.monthlyTimeConsume,
                          weeklyData: state.weeklyTimeConsume,
                          dailyData: state.dailyTimeConsume,
                          top3TodayMostDrainingCards: state.top3TodayMostTimeConsume,
                          top3WeeklyMostDrainingCards: state.top3WeeklyMostTimeConsume,
                          top3MonthlyMostDrainingCards: state.top3MonthlyMostTimeConsume,
                          isAudioPlay: _isAudioPlated,
                          audioPlayer: _audioPlayer,
                          filePath: widget.filePath,
                          top3TodayLeastDrainingCards: state.top3TodayLeastTimeConsume,
                          top3WeeklyLeastDrainingCards: state.top3WeeklyLeastTimeConsume,
                          top3MonthlyLeastDrainingCards: state.top3MonthlyLeastTimeConsume,
                        ),
                      ],
                    ),
                  );
                }
                return ErrorPage();
              },
            ),
    );
  }
}
