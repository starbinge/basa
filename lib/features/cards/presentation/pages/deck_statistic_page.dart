import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:basa_app_project/core/pages/error_page.dart';
import 'package:basa_app_project/features/cards/constants/enums/statistics_page_enum.dart';
import 'package:basa_app_project/features/cards/data/models/flashcard_statistic_model.dart';
import 'package:basa_app_project/features/cards/domain/entities/time_consume_stats_entity.dart';
import 'package:basa_app_project/features/cards/presentation/bloc/flash_card/flash_card_bloc.dart';
import 'package:basa_app_project/features/cards/presentation/widgets/layouts/accuracy_stats_layout.dart';
import 'package:basa_app_project/features/cards/presentation/widgets/layouts/play_time_stats_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

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
    final DateTime _now = DateTime.now();
    final String _monthName = DateFormat.MMMM('en_US').format(_now);
    final int _year = _now.year;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Statistics"),
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
      ),
      body: BlocBuilder<FlashCardBloc, FlashCardState>(
        builder: (context, state) {
          if (state is FlashCardIsLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is FLashCardIsError) {
            return ErrorPage(message: state.errorMessage);
          }
          if (state is AccuracyStatsFinished) {
            return SafeArea(
              child: CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: [
                  AccuracyStatsLayout(
                    stats: state.stats,
                    isAudioPlayed: _isAudioPlated,
                    audioPlayer: _audioPlayer,
                    filePath: widget.filePath,
                  ),
                ],
              ),
            );
          }
          if (state is TimeConsumeStatsFinished) {
            final DeckTimeConsume _thisMonth = state.thisMonth;
            final List<TimeConsumeStatsEntity> _dailyData = [];
            final List<TimeConsumeStatsEntity> _monthlyData = [];
            final List<TimeConsumeStatsEntity> _weeklyData = [];
            state.monthlyAverage.forEach((data) {
              _monthlyData.add(
                TimeConsumeStatsEntity.fromMillieSeconds(
                  timeAvg: data.avgTime,
                  totalTime: data.totalTime,
                ),
              );
            });
            state.weeklyAverage.forEach((data) {
              _weeklyData.add(
                TimeConsumeStatsEntity.fromMillieSeconds(
                  timeAvg: data.avgTime,
                  totalTime: data.totalTime,
                ),
              );
            });
            state.dailyAverage.forEach((data) {
              _dailyData.add(
                TimeConsumeStatsEntity.fromMillieSeconds(
                  timeAvg: data.avgTime,
                  totalTime: data.totalTime,
                ),
              );
            });
            final TimeConsumeStatsEntity _timeStats =
                TimeConsumeStatsEntity.fromMillieSeconds(
                  timeAvg: _thisMonth.avgTime,
                  totalTime: _thisMonth.totalTime,
                );
            return SafeArea(
              child: CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: [
                  PlayTimeStatsLayout(
                    timeStats: _timeStats,
                    monthlyData: _monthlyData,
                    weeklyData: _weeklyData,
                    dailyData: _dailyData,
                    top3TodayMostDrainingCards: state.top3TodayCards,
                    top3WeeklyMostDrainingCards: state.top3WeeklyCards,
                    top3MonthlyMostDrainingCards: state.top3MonthlyCards,
                    isAudioPlay: _isAudioPlated,
                    audioPlayer: _audioPlayer,
                    filePath: widget.filePath,
                    top3TodayLeastDrainingCards: state.top3LeastTodayCards,
                    top3WeeklyLeastDrainingCards: state.top3LeastWeeklyCards,
                    top3MonthlyLeastDrainingCards: state.top3LeastMonthlyCards,
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
