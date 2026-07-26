import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:basa_app_project/core/constants/screen_size.dart';
import 'package:basa_app_project/core/widgets/callendar_heatmap.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';
import 'package:basa_app_project/features/cards/domain/entities/time_consume_entity/time_consume_entity.dart';
import 'package:basa_app_project/features/cards/domain/usecases/get_sidetitles_chart_usecase.dart';
import 'package:basa_app_project/features/cards/presentation/widgets/card_tirelist_container.dart';
import 'package:basa_app_project/features/cards/presentation/widgets/deck_graph_container.dart';
import 'package:basa_app_project/features/cards/presentation/widgets/time_consume_stats_header.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:m3e_core/m3e_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlayTimeStatsLayout extends StatefulWidget {
  const PlayTimeStatsLayout({
    super.key,

    required this.timeStats,
    required this.monthlyData,
    required this.weeklyData,
    required this.dailyData,
    required this.top3TodayMostDrainingCards,
    required this.top3WeeklyMostDrainingCards,
    required this.top3MonthlyMostDrainingCards,
    required this.isAudioPlay,
    required this.audioPlayer,
    required this.filePath,
    required this.top3TodayLeastDrainingCards,
    required this.top3WeeklyLeastDrainingCards,
    required this.top3MonthlyLeastDrainingCards,
  });

  final TimeConsumeEntity timeStats;
  final List<TimeConsumeEntity> monthlyData;
  final List<TimeConsumeEntity> weeklyData;
  final List<TimeConsumeEntity> dailyData;
  final List<CardsDetailEntity> top3TodayMostDrainingCards;
  final List<CardsDetailEntity> top3WeeklyMostDrainingCards;
  final List<CardsDetailEntity> top3MonthlyMostDrainingCards;
  final bool isAudioPlay;
  final AudioPlayer audioPlayer;
  final File filePath;
  final List<CardsDetailEntity> top3TodayLeastDrainingCards;
  final List<CardsDetailEntity> top3WeeklyLeastDrainingCards;
  final List<CardsDetailEntity> top3MonthlyLeastDrainingCards;
  @override
  State<PlayTimeStatsLayout> createState() => _PlayTimeStatsLayoutState();
}

class _PlayTimeStatsLayoutState extends State<PlayTimeStatsLayout> {
  int _selectedPage = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final displayLarge = Theme.of(context).textTheme.displayLarge;
    final displayMedium = Theme.of(context).textTheme.displayMedium;
    final headlineSmall = Theme.of(context).textTheme.headlineSmall;
    final labelLarge = Theme.of(context).textTheme.labelLarge;
    final DateTime _now = DateTime.now();
    final String _monthName = widget.timeStats.timeLabel;
    final int _year = _now.year;

    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: RepaintBoundary(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TimeConsumeStatsHeader(
                    widget: widget,
                    displayLarge: displayLarge,
                    displayMedium: displayMedium,
                    headlineSmall: headlineSmall,
                    labelLarge: labelLarge,
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Column(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RepaintBoundary(
                child: Text(
                  _selectedPage != 2 ? "$_monthName $_year" : "$_year",
                  key: ValueKey<int>(_selectedPage),
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge!.copyWith(fontSize: 40),
                ),
              ),
              Text(
                "Active Time Statistics",
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontSize: 15),
              ),
              Center(
                child: Container(
                  width: context.screenWidth / 2,
                  child: Text(
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    "Visually served information of your activity for this deck.",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),

              Center(
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
              SizedBox(
                height: 1120.h,
                child: PageView(
                  physics: BouncingScrollPhysics(),
                  onPageChanged: (int pageIndex) => setState(() {
                    _selectedPage = pageIndex;
                  }),
                  controller: _pageController,
                  children: [
                    Column(
                      children: [
                        CallendarHeatmap(
                          itemCount: widget.dailyData.length,
                          getValue: (i) {
                            final minutes =
                                widget.dailyData[i].totalTime.hour * 60 +
                                widget.dailyData[i].totalTime.minute;
                            return minutes == 0
                                ? 0.0
                                : minutes / widget.dailyData.length;
                          },
                        ),
                        CardTierListContainer(
                          titleText: "Top 3 Most Draining Time Cards",
                          iconShape: Icons.av_timer_rounded,
                          backgroundColor: Theme.of(context).primaryColorDark,
                          strokeColor: Colors.blue.shade900,
                          iconColor: Colors.white,
                          cardsData: widget.top3TodayMostDrainingCards,
                          carouselBackgroundColor: Theme.of(
                            context,
                          ).primaryColorDark,
                          carouselForgroundColor: Colors.white,
                          isAudioPlay: widget.isAudioPlay,
                          audioPlayer: widget.audioPlayer,
                          filePath: widget.filePath,
                        ),
                        CardTierListContainer(
                          titleText: "Top 3 Least Draining Time Cards",
                          iconShape: Icons.av_timer_rounded,
                          backgroundColor: Theme.of(context).colorScheme.error,
                          strokeColor: Colors.red.shade900,
                          iconColor: Colors.white,
                          cardsData: widget.top3TodayLeastDrainingCards,
                          carouselBackgroundColor: Theme.of(
                            context,
                          ).colorScheme.error,
                          carouselForgroundColor: Colors.white,
                          isAudioPlay: widget.isAudioPlay,
                          audioPlayer: widget.audioPlayer,
                          filePath: widget.filePath,
                        ),
                      ],
                    ),
                    RepaintBoundary(
                      child: Column(
                        children: [
                          DeckGraphContainer(
                            data: widget.weeklyData,
                            getTitlesWidget: (double axisX, TitleMeta meta) {
                              return getWeeklyTitleByIndexFunction(
                                axisX: axisX,
                                meta: meta,
                              );
                            },
                            getYValue: (TimeConsumeEntity item) =>
                                (item.totalTime.hour * 60 + item.totalTime.minute).toDouble(),
                          ),
                          CardTierListContainer(
                            titleText: "Top 3 Most Draining Time Cards",
                            iconShape: Icons.av_timer_rounded,
                            backgroundColor: Theme.of(context).primaryColor,
                            strokeColor: Colors.blue.shade900,
                            iconColor: Colors.white,
                            cardsData: widget.top3WeeklyMostDrainingCards,
                            carouselBackgroundColor: Theme.of(
                              context,
                            ).primaryColorDark,
                            carouselForgroundColor: Colors.white,
                            isAudioPlay: widget.isAudioPlay,
                            audioPlayer: widget.audioPlayer,
                            filePath: widget.filePath,
                          ),
                          CardTierListContainer(
                            titleText: "Top 3 Least Draining Time Cards",
                            iconShape: Icons.av_timer_rounded,
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.error,
                            strokeColor: Colors.red.shade900,
                            iconColor: Colors.white,
                            cardsData: widget.top3WeeklyLeastDrainingCards,
                            carouselBackgroundColor: Theme.of(
                              context,
                            ).colorScheme.error,
                            carouselForgroundColor: Colors.white,
                            isAudioPlay: widget.isAudioPlay,
                            audioPlayer: widget.audioPlayer,
                            filePath: widget.filePath,
                          ),
                        ],
                      ),
                    ),
                    RepaintBoundary(
                      child: Column(
                        children: [
                          DeckGraphContainer<TimeConsumeEntity>(
                            data: widget.monthlyData,
                            getTitlesWidget: (double axisX, TitleMeta meta) {
                              return getMonthlyTitleByIndexFunction(
                                axisX: axisX,
                                meta: meta,
                              );
                            },
                            getYValue: (TimeConsumeEntity item) =>
                                (item.totalTime.hour * 60 + item.totalTime.minute).toDouble(),
                          ),
                          CardTierListContainer(
                            titleText: "Top 3 Most Draining Time Cards",
                            iconShape: Icons.av_timer_rounded,
                            backgroundColor: Theme.of(context).primaryColorDark,
                            strokeColor: Colors.blue.shade900,
                            iconColor: Colors.white,
                            cardsData: widget.top3MonthlyMostDrainingCards,
                            carouselBackgroundColor: Theme.of(
                              context,
                            ).primaryColorDark,
                            carouselForgroundColor: Colors.white,
                            isAudioPlay: widget.isAudioPlay,
                            audioPlayer: widget.audioPlayer,
                            filePath: widget.filePath,
                          ),
                          CardTierListContainer(
                            titleText: "Top 3 Least Draining Time Cards",
                            iconShape: Icons.av_timer_rounded,
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.error,
                            strokeColor: Colors.red.shade900,
                            iconColor: Colors.white,
                            cardsData: widget.top3MonthlyLeastDrainingCards,
                            carouselBackgroundColor: Theme.of(
                              context,
                            ).colorScheme.error,
                            carouselForgroundColor: Colors.white,
                            isAudioPlay: widget.isAudioPlay,
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
      ],
    );
  }
}
