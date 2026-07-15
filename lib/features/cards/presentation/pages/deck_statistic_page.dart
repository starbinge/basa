import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:basa_app_project/core/pages/error_page.dart';
import 'package:basa_app_project/features/cards/constants/enums/chart_category_enum.dart';
import 'package:basa_app_project/features/cards/constants/enums/statistics_page_enum.dart';
import 'package:basa_app_project/features/cards/data/models/flashcard_statistic_model.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_entity.dart';
import 'package:basa_app_project/features/cards/domain/entities/segmented_button_entity.dart';
import 'package:basa_app_project/features/cards/presentation/bloc/flash_card/flash_card_bloc.dart';
import 'package:basa_app_project/features/cards/presentation/widgets/card_tirelist_container.dart';
import 'package:basa_app_project/features/cards/presentation/widgets/deck_graph_container.dart';
import 'package:basa_app_project/features/cards/presentation/widgets/segmented_button.dart';
import 'package:basa_app_project/features/cards/presentation/widgets/vocab_cards.dart';
import 'package:drift/backends.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_m3shapes_extended/flutter_m3shapes_extended.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../domain/usecases/get_sidetitles_chart_usecase.dart';
import '../widgets/stats_percentage_container.dart';

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
  PageController _pageController = PageController();
  int _openedPage = 0;
  bool _isAudioPlated = false;
  AudioPlayer _audioPlayer = AudioPlayer();
  @override
  void initState() {
    super.initState();
  }

  final Map<ChartCategoryEnum, String> buttonSegment = {
    ChartCategoryEnum.Monthly: "Monthly",
    ChartCategoryEnum.Weekly: "Weekly",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            final DeckAccuracy _thisMonthStats =
                state.stats.thisMonthDeckAccuracy;
            final DeckAccuracy _previousMonthStats =
                state.stats.previousMonthDeckAccuracy;
            final List<DeckAccuracy> _monthlyData = state.stats.monthlyList;
            final List<DeckAccuracy> _weeklyData = state.stats.weeklyList;
            debugPrint(state.stats.top3LeastAccurate.length.toString());
            return SafeArea(
              child: CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Deck Accuracy',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(10),
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
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
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
                                DeckGraphContainer(
                                  data: _monthlyData,
                                  getTitlesWidget:
                                      (double axisX, TitleMeta meta) {
                                        return getMonthlyTitleByIndexFunction(
                                          axisX: axisX,
                                          meta: meta,
                                        );
                                      },
                                ),
                                DeckGraphContainer(
                                  data: _weeklyData,
                                  getTitlesWidget:
                                      (double axisX, TitleMeta meta) {
                                        return getWeeklyTitleByIndexFunction(
                                          axisX: axisX,
                                          meta: meta,
                                        );
                                      },
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            width: double.infinity,
                            child: Text(
                              textAlign: TextAlign.left,
                              "🛈 Press the bar to see more detail information",
                              style: Theme.of(context).textTheme.labelMedium
                                  ?.copyWith(color: Colors.grey),
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
                    cardsData: state.stats.top3MostAccurate,
                    carouselBackgroundColor: Theme.of(context).primaryColor,
                    carouselForgroundColor: Colors.white,
                    isAudioPlay: _isAudioPlated,
                    audioPlayer: _audioPlayer,
                    filePath: widget.filePath,
                  ),
                  CardTierListContainer(
                    titleText: "Top 3 Least Accurate Vocabularies",
                    iconShape: Icons.trending_down_rounded,
                    backgroundColor: Theme.of(context).colorScheme.error,
                    strokeColor: Colors.red.shade900,
                    iconColor: Colors.white,
                    cardsData: state.stats.top3LeastAccurate,
                    carouselBackgroundColor: Theme.of(
                      context,
                    ).colorScheme.error,
                    carouselForgroundColor: Colors.white,
                    isAudioPlay: _isAudioPlated,
                    audioPlayer: _audioPlayer,
                    filePath: widget.filePath,
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
