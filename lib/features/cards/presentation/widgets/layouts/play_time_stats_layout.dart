import 'package:basa_app_project/core/constants/screen_size.dart';
import 'package:basa_app_project/core/widgets/callendar_heatmap.dart';
import 'package:basa_app_project/features/cards/domain/entities/time_consume_entity/time_consume_entity.dart';
import 'package:basa_app_project/features/cards/domain/usecases/get_sidetitles_chart_usecase.dart';
import 'package:basa_app_project/features/cards/domain/usecases/get_start_end_date.dart';
import 'package:basa_app_project/features/cards/presentation/bloc/statistics/time_consume/time_consume_bloc.dart';
import 'package:basa_app_project/features/cards/presentation/widgets/statistics/shared/deck_graph_container.dart';
import 'package:basa_app_project/features/cards/presentation/widgets/statistics/shared/segmented_button_time_Selection.dart';
import 'package:basa_app_project/features/cards/presentation/widgets/statistics/time_consume/time_consume_stats_header.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../statistics/shared/bottom_sheet_stats.dart';
import '../../../constants/enums/date_range_granularity_enum.dart';

class PlayTimeStatsLayout extends StatefulWidget {
  const PlayTimeStatsLayout({
    super.key,

    required this.timeStats,
    required this.monthlyData,

    required this.dailyData,
  });

  final TimeConsumeEntity timeStats;
  final List<TimeConsumeEntity> monthlyData;

  final List<TimeConsumeEntity> dailyData;

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
                  const SizedBox(height: 30),
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

              SegmentedButtonTimeSelection(
                selectedPage: _selectedPage,
                onSelectedIndexChanged: (int selectedIndex) => setState(() {
                  _selectedPage = selectedIndex;
                  _pageController.animateToPage(
                    selectedIndex,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }),
              ),
              SizedBox(
                height: 280.h,
                child: PageView(
                  physics: const BouncingScrollPhysics(),
                  onPageChanged: (int pageIndex) => setState(() {
                    _selectedPage = pageIndex;
                  }),
                  controller: _pageController,
                  children: [
                    Column(
                      children: [
                        CallendarHeatmap(
                          itemCount: widget.dailyData.length,
                          year: _now.year,
                          month: _now.month,
                          getValue: (i) {
                            final seconds =
                                widget.dailyData[i].totalTime.seconds;
                            return seconds == 0 ? 0.0 : seconds / 100;
                          },
                          onDateTap: (DateTime date) {
                            onDateTap(
                              date: date,
                              monthName: DateFormat.MMMM('en_US').format(date),
                              granularity: DateRangeGranularity.daily,
                            );
                          },
                        ),
                      ],
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
                                item.totalTime.minute.roundToDouble(),
                            maxY: widget.monthlyData.isEmpty
                                ? 100
                                : widget.monthlyData
                                      .map(
                                        (item) =>
                                            (item.totalTime.minute).toDouble(),
                                      )
                                      .reduce((a, b) => a > b ? a : b),
                            onBarTap: (int barIndex) {
                              if (barIndex <= 0) return;
                              final int year = DateTime.now().year;
                              final DateTime date = DateTime(year, barIndex);
                              final String monthName = DateFormat.MMMM(
                                'en_US',
                              ).format(date);
                              onDateTap(date: date, monthName: monthName, granularity: DateRangeGranularity.monthly);
                            },
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

  void onDateTap({required DateTime date, required String monthName, required DateRangeGranularity granularity}) {
    final bloc = context.read<TimeConsumeBloc>();
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
          value: bloc
            ..add(
              GetTopCards(
                begin: begin,
                end: end,
              ),
            ),
          child: BlocBuilder<TimeConsumeBloc, TimeConsumeState>(
            builder: (context, state) {
              bool isLoading =
                  state is! TimeConsumeDetailLoaded ||
                  state.mostTimeConsumingCards == null;
              bool isEmpty =
                  state is TimeConsumeDetailLoaded &&
                  state.mostTimeConsumingCards != null &&
                  state.mostTimeConsumingCards!.isEmpty;
              bool isFutureDate = date.isAfter(DateTime.now());

              return BottomSheetStats(
                isLoading: isLoading,
                isEmpty: isEmpty,
                isFutureDate: isFutureDate,
                date: date.day,
                monthName: monthName,
                title: "The Most Time Consuming Cards",
                listCards:
                    state is TimeConsumeDetailLoaded &&
                        state.mostTimeConsumingCards != null
                    ? state.mostTimeConsumingCards!
                          .map((data) => data.card)
                          .toList()
                    : [],
                avgStatValue: state is TimeConsumeDetailLoaded
                    ? (state.avgTime ?? const TimeUnit(hour: 0, minute: 0, seconds: 0)).formatted
                    : const TimeUnit(hour: 0, minute: 0, seconds: 0).formatted,
                avgStatLabel: 'Avg',
                totalCards: state is TimeConsumeDetailLoaded
                    ? (state.totalCard ?? 0)
                    : 0,
                totalTime: state is TimeConsumeDetailLoaded
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
