import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:basa_app_project/features/cards/data/models/flashcard_statistic_model.dart';
import 'package:basa_app_project/features/cards/presentation/widgets/card_tirelist_container.dart';
import 'package:basa_app_project/features/cards/presentation/widgets/deck_graph_container.dart';
import 'package:basa_app_project/features/cards/presentation/widgets/segmented_button.dart';
import 'package:basa_app_project/features/cards/domain/entities/segmented_button_entity.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../domain/usecases/get_sidetitles_chart_usecase.dart';
import '../stats_percentage_container.dart';

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
  int _openedPage = 0;

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

    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: StatsPercentageContainer(
              thisMonthStats: _thisMonthStats.accuracyNumber,
              previousMonthStats: _previousMonthStats.accuracyNumber,
              titleCards: 'This Month\'s Card Accuracy',
              backgroundIcon: Icons.polyline_outlined,
              backgroundColor: Theme.of(context).primaryColor,
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
                  "Statistic Graphs",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  "Visually served information of your accuracy for this deck.",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: BoxBorder.all(width: 1),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: SegmentedButtonCustom(
                    listOfButtons: [
                      SegmentedButtonEntity(
                        onTap: () {
                          _pageController.previousPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                          setState(() {
                            _openedPage = 0;
                          });
                        },
                        backgroundColor: ColorPreference(
                          selectedColor: Colors.pink,
                          unselectedColor: Colors.transparent,
                        ),
                        foregroundColor: ColorPreference(
                          selectedColor: Colors.white,
                          unselectedColor: Colors.grey,
                        ),
                        text: "Monthly",
                        selectionParamter: _openedPage == 0,
                        borderRadiusSize: 30,
                      ),
                      SegmentedButtonEntity(
                        onTap: () {
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                          setState(() {
                            _openedPage = 1;
                          });
                        },
                        backgroundColor: ColorPreference(
                          selectedColor: Colors.pink,
                          unselectedColor: Colors.transparent,
                        ),
                        foregroundColor: ColorPreference(
                          selectedColor: Colors.white,
                          unselectedColor: Colors.grey,
                        ),
                        text: "Weekly",
                        selectionParamter: _openedPage == 1,
                        borderRadiusSize: 30,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 300.h,
                  child: PageView(
                    physics: BouncingScrollPhysics(),
                    onPageChanged: (int pageIndex) => setState(() {
                      _openedPage = pageIndex;
                    }),
                    controller: _pageController,
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        CardTierListContainer(
          titleText: 'Top 3 Most Accurate Vocabularies',
          iconShape: Icons.emoji_events_rounded,
          backgroundColor: Colors.amber,
          strokeColor: Colors.orange.shade900,
          iconColor: Colors.white,
          cardsData: widget.stats.top3MostAccurate,
          carouselBackgroundColor: Theme.of(context).primaryColor,
          carouselForgroundColor: Colors.white,
          isAudioPlay: widget.isAudioPlayed,
          audioPlayer: widget.audioPlayer,
          filePath: widget.filePath,
        ),
        CardTierListContainer(
          titleText: "Top 3 Least Accurate Vocabularies",
          iconShape: Icons.trending_down_rounded,
          backgroundColor: Theme.of(context).colorScheme.error,
          strokeColor: Colors.red.shade900,
          iconColor: Colors.white,
          cardsData: widget.stats.top3LeastAccurate,
          carouselBackgroundColor: Theme.of(context).colorScheme.error,
          carouselForgroundColor: Colors.white,
          isAudioPlay: widget.isAudioPlayed,
          audioPlayer: widget.audioPlayer,
          filePath: widget.filePath,
        ),
      ],
    );
  }
}
