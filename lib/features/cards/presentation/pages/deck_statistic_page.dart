import 'package:basa_app_project/core/constants/screen_size.dart';
import 'package:basa_app_project/core/pages/error_page.dart';
import 'package:basa_app_project/features/cards/constants/enums/chart_category_enum.dart';
import 'package:basa_app_project/features/cards/constants/enums/statistics_page_enum.dart';
import 'package:basa_app_project/features/cards/data/models/flashcard_statistic_model.dart';
import 'package:basa_app_project/features/cards/presentation/bloc/flash_card/flash_card_bloc.dart';
import 'package:basa_app_project/features/cards/presentation/widgets/deck_graph_container.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbols.dart';

import '../../domain/usecases/get_sidetitles_chart_usecase.dart';
import '../widgets/stats_percentage_container.dart';

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
  // final DateTime _dateTime = DateTime.now();
  PageController _pageController = PageController();
  int _openedPage = 0;

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
            return SafeArea(
              child: CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Deck Accuracy',
                        style: TextStyle(
                          fontSize: TextTheme.of(
                            context,
                          ).displaySmall?.fontSize,
                        ),
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
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: BoxBorder.all(width: 1),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 10,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _pageController.previousPage(
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                    setState(() {
                                      _openedPage = 0;
                                    });
                                  },
                                  child: AnimatedContainer(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 5,
                                      horizontal: _openedPage == 0 ? 15 : 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _openedPage == 0
                                          ? Colors.black
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    constraints: BoxConstraints(
                                      maxWidth: 100,
                                      maxHeight: 200,
                                    ),
                                    child: Text(
                                      ChartCategoryEnum.Monthly.name,
                                      style: TextStyle(
                                        color: _openedPage == 0
                                            ? Colors.white
                                            : Colors.grey,
                                      ),
                                    ),
                                    duration: Duration(milliseconds: 300),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _pageController.nextPage(
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                    setState(() {
                                      _openedPage = 1;
                                    });
                                  },
                                  child: AnimatedContainer(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 5,
                                      horizontal: _openedPage == 1 ? 15 : 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _openedPage == 1
                                          ? Colors.black
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    constraints: BoxConstraints(
                                      maxWidth: 100,
                                      maxHeight: 200,
                                    ),
                                    child: Text(
                                      ChartCategoryEnum.Monthly.name,
                                      style: TextStyle(
                                        color: _openedPage == 1
                                            ? Colors.white
                                            : Colors.grey,
                                      ),
                                    ),
                                    duration: Duration(milliseconds: 300),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 450.h,
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
                        ],
                      ),
                    ),
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
