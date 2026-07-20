import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:basa_app_project/core/widgets/callendar_heatmap.dart';
import 'package:basa_app_project/features/cards/data/models/flashcard_statistic_model.dart';
import 'package:basa_app_project/features/cards/presentation/widgets/card_tirelist_container.dart';
import 'package:basa_app_project/features/cards/presentation/widgets/deck_graph_container.dart';
import 'package:basa_app_project/features/cards/domain/usecases/get_sidetitles_chart_usecase.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:m3e_core/m3e_core.dart';

import '../accuracy_stats_header.dart';

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
    final List<DeckAccuracy> _weeklyData = widget.stats.weeklyList;
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
                Center(
                  child: RepaintBoundary(
                    child: M3EToggleButtonGroup(
                      onSelectedIndexChanged: (selectedIndex) => setState(() {
                        _selectedPage = selectedIndex!;
                        _pageController.animateToPage(
                          selectedIndex,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }),
                      selectedIndex: _selectedPage,
                      type: M3EButtonGroupType.connected,
                      actions: [
                        M3EToggleButtonGroupAction(
                          icon: const Icon(Icons.calendar_month_rounded),
                          label: null,
                          checkedLabel: Text(
                            "Daily",
                            style: TextStyle(fontWeight: FontWeight.w900),
                          ),
                          decoration: M3EToggleButtonDecoration(
                            backgroundColor: WidgetStatePropertyAll(
                              _selectedPage == 0
                                  ? Theme.of(context).primaryColorDark
                                  : Colors.grey.withValues(alpha: 0.2),
                            ),
                          ),
                        ),
                        M3EToggleButtonGroupAction(
                          decoration: M3EToggleButtonDecoration(
                            backgroundColor: WidgetStatePropertyAll(
                              _selectedPage == 1
                                  ? Theme.of(context).primaryColorDark
                                  : Colors.grey.withValues(alpha: 0.2),
                            ),
                          ),
                          icon: const Icon(Icons.calendar_view_week_rounded),
                          label: null,
                          checkedLabel: Text(
                            "Weekly",
                            style: TextStyle(fontWeight: FontWeight.w900),
                          ),
                        ),
                        M3EToggleButtonGroupAction(
                          icon: const Icon(Icons.calendar_view_month),
                          label: null,
                          checkedLabel: Text(
                            "Monthly",
                            style: TextStyle(fontWeight: FontWeight.w900),
                          ),
                          decoration: M3EToggleButtonDecoration(
                            backgroundColor: WidgetStatePropertyAll(
                              _selectedPage == 2
                                  ? Theme.of(context).primaryColorDark
                                  : Colors.grey.withValues(alpha: 0.2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 1120.h,
                  child: PageView(
                    physics: BouncingScrollPhysics(),
                    onPageChanged: (int pageIndex) => setState(() {
                      _selectedPage = pageIndex;
                    }),
                    controller: _pageController,
                    children: [
                      RepaintBoundary(
                        child: Column(
                          children: [
                            CallendarHeatmap(
                              itemCount: widget.stats.dailyAccuracyList.length,
                              getValue: (i) =>
                                  widget
                                      .stats
                                      .dailyAccuracyList[i]
                                      .accuracyNumber /
                                  100,
                            ),
                            CardTierListContainer(
                              titleText: "Top 3 Most Accurate Cards",
                              iconShape: Icons.emoji_events_rounded,
                              backgroundColor: Colors.amber,
                              strokeColor: Colors.orange.shade900,
                              iconColor: Colors.white,
                              cardsData: widget.stats.top3TodayMostAccurate,
                              carouselBackgroundColor: Theme.of(
                                context,
                              ).primaryColor,
                              carouselForgroundColor: Colors.white,
                              isAudioPlay: widget.isAudioPlayed,
                              audioPlayer: widget.audioPlayer,
                              filePath: widget.filePath,
                            ),
                            CardTierListContainer(
                              titleText: "Top 3 Least Accurate Cards",
                              iconShape: Icons.trending_down_rounded,
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.error,
                              strokeColor: Colors.red.shade900,
                              iconColor: Colors.white,
                              cardsData: widget.stats.top3TodayLeastAccurate,
                              carouselBackgroundColor: Theme.of(
                                context,
                              ).colorScheme.error,
                              carouselForgroundColor: Colors.white,
                              isAudioPlay: widget.isAudioPlayed,
                              audioPlayer: widget.audioPlayer,
                              filePath: widget.filePath,
                            ),
                          ],
                        ),
                      ),
                      RepaintBoundary(
                        child: Column(
                          children: [
                            DeckGraphContainer<DeckAccuracy>(
                              data: _weeklyData,
                              getTitlesWidget: (double axisX, TitleMeta meta) {
                                return getWeeklyTitleByIndexFunction(
                                  axisX: axisX,
                                  meta: meta,
                                );
                              },
                              getYValue: (DeckAccuracy item) =>
                                  item.accuracyNumber.toDouble(),
                            ),
                            CardTierListContainer(
                              titleText: "Top 3 Most Accurate Cards",
                              iconShape: Icons.emoji_events_rounded,
                              backgroundColor: Colors.amber,
                              strokeColor: Colors.orange.shade900,
                              iconColor: Colors.white,
                              cardsData: widget.stats.top3WeeklyMostAccurate,
                              carouselBackgroundColor: Theme.of(
                                context,
                              ).primaryColor,
                              carouselForgroundColor: Colors.white,
                              isAudioPlay: widget.isAudioPlayed,
                              audioPlayer: widget.audioPlayer,
                              filePath: widget.filePath,
                            ),
                            CardTierListContainer(
                              titleText: "Top 3 Least Accurate Cards",
                              iconShape: Icons.trending_down_rounded,
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.error,
                              strokeColor: Colors.red.shade900,
                              iconColor: Colors.white,
                              cardsData: widget.stats.top3WeeklyLeastAccurate,
                              carouselBackgroundColor: Theme.of(
                                context,
                              ).colorScheme.error,
                              carouselForgroundColor: Colors.white,
                              isAudioPlay: widget.isAudioPlayed,
                              audioPlayer: widget.audioPlayer,
                              filePath: widget.filePath,
                            ),
                          ],
                        ),
                      ),
                      RepaintBoundary(
                        child: Column(
                          children: [
                            DeckGraphContainer<DeckAccuracy>(
                              data: _monthlyData,
                              getTitlesWidget: (double axisX, TitleMeta meta) {
                                return getMonthlyTitleByIndexFunction(
                                  axisX: axisX,
                                  meta: meta,
                                );
                              },
                              getYValue: (DeckAccuracy item) =>
                                  item.accuracyNumber.toDouble(),
                            ),
                            CardTierListContainer(
                              titleText: "Top 3 Most Accurate Cards",
                              iconShape: Icons.emoji_events_rounded,
                              backgroundColor: Colors.amber,
                              strokeColor: Colors.orange.shade900,
                              iconColor: Colors.white,
                              cardsData: widget.stats.top3MonthlyMostAccurate,
                              carouselBackgroundColor: Theme.of(
                                context,
                              ).primaryColor,
                              carouselForgroundColor: Colors.white,
                              isAudioPlay: widget.isAudioPlayed,
                              audioPlayer: widget.audioPlayer,
                              filePath: widget.filePath,
                            ),
                            CardTierListContainer(
                              titleText: "Top 3 Least Accurate Cards",
                              iconShape: Icons.trending_down_rounded,
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.error,
                              strokeColor: Colors.red.shade900,
                              iconColor: Colors.white,
                              cardsData: widget.stats.top3MonthlyLeastAccurate,
                              carouselBackgroundColor: Theme.of(
                                context,
                              ).colorScheme.error,
                              carouselForgroundColor: Colors.white,
                              isAudioPlay: widget.isAudioPlayed,
                              audioPlayer: widget.audioPlayer,
                              filePath: widget.filePath,
                            ),
                          ],
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
}
