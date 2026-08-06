import 'package:basa_app_project/core/pages/error_page.dart';
import 'package:basa_app_project/core/widgets/animated_header.dart';
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
  });

  final String deckName;
  final StatisticsPageEnum statsType;

  @override
  State<DeckStatisticPage> createState() => _DeckStatisticPageState();
}

class _DeckStatisticPageState extends State<DeckStatisticPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Statistics"),
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
      ),
      body: widget.statsType == StatisticsPageEnum.accuracy
          ? BlocBuilder<CardAccuracyBloc, CardAccuracyState>(
              builder: (context, state) {
                if (state is CardAccuracyLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is CardAccuracyError) {
                  return ErrorPage(message: state.errorMessage);
                }
                if (state is AccuracyDetailLoaded) {
                  final bool isEmpty =
                      state.dailyAccuracy.isEmpty &&
                      state.monthlyAccuracy.isEmpty;

                  if (isEmpty) {
                    return const SafeArea(
                      child: AnimatedHeader(icon: Icons.bar_chart_rounded),
                    );
                  }
                  return SafeArea(
                    child: CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        AccuracyStatsLayout(
                          stats: DeckAccuracyStats(
                            thisMonthDeckAccuracy: state.thisMonthAccuracy,
                            previousMonthDeckAccuracy:
                                state.previousMonthAccuracy,

                            monthlyList: state.monthlyAccuracy,
                            dailyAccuracyList: state.dailyAccuracy,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const ErrorPage();
              },
            )
          : BlocBuilder<TimeConsumeBloc, TimeConsumeState>(
              builder: (context, state) {
                if (state is TimeConsumeLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is TimeConsumeError) {
                  return ErrorPage(message: state.errorMessage);
                }
                if (state is TimeConsumeDetailLoaded) {
                  final bool isEmpty =
                      state.dailyTimeConsume.isEmpty &&
                      state.monthlyTimeConsume.isEmpty;

                  if (isEmpty) {
                    return const SafeArea(
                      child: AnimatedHeader(icon: Icons.timer_outlined),
                    );
                  }
                  return SafeArea(
                    child: CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        PlayTimeStatsLayout(
                          timeStats: state.thisMonthTimeConsume,
                          monthlyData: state.monthlyTimeConsume,
                          dailyData: state.dailyTimeConsume,
                        ),
                      ],
                    ),
                  );
                }
                return const ErrorPage();
              },
            ),
    );
  }
}
