import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:basa_app_project/core/widgets/callendar_heatmap.dart';
import 'package:basa_app_project/features/cards/data/models/flashcard_statistic_model.dart';
import 'package:basa_app_project/features/cards/domain/entities/time_consume_entity/time_consume_entity.dart';
import 'package:basa_app_project/features/cards/domain/usecases/get_sidetitles_chart_usecase.dart';
import 'package:basa_app_project/features/cards/domain/usecases/get_start_end_date.dart';
import 'package:basa_app_project/features/cards/presentation/widgets/statistics/shared/deck_graph_container.dart';
import 'package:basa_app_project/features/cards/presentation/widgets/statistics/shared/segmented_button_time_Selection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../constants/enums/date_range_granularity_enum.dart';
import '../../bloc/statistics/card_accuracy/card_accuracy_bloc.dart';
import '../statistics/accuracy/accuracy_stats_header.dart';
import '../statistics/shared/bottom_sheet_stats.dart';

class AccuracyStatsLayout extends StatefulWidget {
  const AccuracyStatsLayout({
    super.key,
    required this.stats,
    required this.isAudioPlayed,
    required this.audioPlayer,
    required this.filePath,
  });

  final DeckAccuracyStats stats;
  final bool isAudioPlayed;
  final AudioPlayer audioPlayer;
  final File filePath;

  @override
  State<AccuracyStatsLayout> createState() => _AccuracyStatsLayoutState();
}

class _AccuracyStatsLayoutState extends State<AccuracyStatsLayout> {
  final PageController _pageController = PageController();
  int _selectedPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DeckAccuracy _thisMonthStats = widget.stats.thisMonthDeckAccuracy;
    final DeckAccuracy _previousMonthStats =
        widget.stats.previousMonthDeckAccuracy;
    final List<DeckAccuracy> _monthlyData = widget.stats.monthlyList;
    final DateTime _now = DateTime.now();
    final String _monthName = DateFormat.MMMM('en_US').format(_now);
    final int _year = _now.year;

    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: RepaintBoundary(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: AccuracyStatsHeader(
                thisMonthStats: _thisMonthStats.accuracyNumber,
                previousMonthStats: _previousMonthStats.accuracyNumber,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 20)),
        SliverToBoxAdapter(
          child: Container(
            child: Column(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  _selectedPage != 2 ? "$_monthName $_year" : "$_year",
                  key: ValueKey<int>(_selectedPage),
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge!.copyWith(fontSize: 40),
                ),
                Text(
                  "Accuracy Statistics",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  "Visually served information of your accuracy for this deck.",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                SegmentedButtonTimeSelection(
                  selectedPage: _selectedPage,
                  onSelectedIndexChanged: (int selectedIndex) {
                    setState(() {
                      _selectedPage = selectedIndex;
                      _pageController.animateToPage(
                        selectedIndex,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    });
                  },
                ),
                SizedBox(
                  height: 280.h,
                  child: PageView(
                    physics: BouncingScrollPhysics(),
                    onPageChanged: (int pageIndex) => setState(() {
                      _selectedPage = pageIndex;
                    }),
                    controller: _pageController,
                    children: [
                      RepaintBoundary(
                        child: CallendarHeatmap(
                          itemCount: widget.stats.dailyAccuracyList.length,
                          getValue: (i) =>
                              widget.stats.dailyAccuracyList[i].accuracyNumber /
                              100,
                          onDateTap: (DateTime date) {
                            onDateTap(
                              date: date,
                              monthName: DateFormat.MMMM('en_US').format(date),
                              granularity: DateRangeGranularity.daily,
                            );
                          },
                        ),
                      ),
                      RepaintBoundary(
                        child: DeckGraphContainer<DeckAccuracy>(
                          maxY: 100,
                          data: _monthlyData,
                          getTitlesWidget: (double axisX, TitleMeta meta) {
                            return getMonthlyTitleByIndexFunction(
                              axisX: axisX,
                              meta: meta,
                            );
                          },
                          getYValue: (DeckAccuracy item) =>
                              item.accuracyNumber.toDouble(),
                          onBarTap: (int barIndex) {
                            if (barIndex <= 0) return;
                            final int year = DateTime.now().year;
                            final DateTime date = DateTime(year, barIndex);
                            final String monthName = DateFormat.MMMM(
                              'en_US',
                            ).format(date);
                            onDateTap(
                              date: date,
                              monthName: monthName,
                              granularity: DateRangeGranularity.monthly,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void onDateTap({
    required DateTime date,
    required String monthName,
    required DateRangeGranularity granularity,
  }) {
    final bloc = context.read<CardAccuracyBloc>();
    final int begin;
    final int end;
    if (granularity == DateRangeGranularity.monthly) {
      begin = getStartOfMonthEpoch(time: date);
      end = getStartOfNextMonthEpoch(time: date);
    } else {
      begin = getStartOfTodayEpoch(time: date);
      end = getEndOfTodayEpoch(time: date);
    }
    showModalBottomSheet(
      clipBehavior: Clip.antiAlias,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (_) {
        return BlocProvider.value(
          value: bloc..add(FetchTop3Cards(begin: begin, end: end)),
          child: BlocBuilder<CardAccuracyBloc, CardAccuracyState>(
            builder: (context, state) {
              bool isLoading =
                  state is! AccuracyDetailLoaded ||
                  state.top3LeastAccurate == null;
              bool isEmpty =
                  state is AccuracyDetailLoaded &&
                  state.top3LeastAccurate != null &&
                  state.top3LeastAccurate!.isEmpty;
              bool isFutureDate = date.isAfter(DateTime.now());
              return BottomSheetStats(
                isLoading: isLoading,
                isEmpty: isEmpty,
                isFutureDate: isFutureDate,
                date: date.day,
                monthName: monthName,
                title: "The Most Inaccurate Cards",
                listCards: state is AccuracyDetailLoaded
                    ? state.top3LeastAccurate ?? []
                    : [],
                avgStatValue: state is AccuracyDetailLoaded
                    ? '${state.avgAccuracy ?? 0}%'
                    : '0%',
                avgStatLabel: 'Accuracy',
                totalCards: state is AccuracyDetailLoaded
                    ? (state.totalCard ?? 0)
                    : 0,
                totalTime: state is AccuracyDetailLoaded
                    ? (state.totalTime ?? const TimeUnit(hour: 0, minute: 0, seconds: 0))
                    : const TimeUnit(hour: 0, minute: 0, seconds: 0),
              );
            },
          ),
        );
      },
    );
  }
}
