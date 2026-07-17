import 'package:audioplayers/audioplayers.dart';
import 'package:basa_app_project/core/constants/screen_size.dart';
import 'package:basa_app_project/core/theme/app_colors.dart';
import 'package:basa_app_project/core/widgets/callendar_heatmap.dart';
import 'package:basa_app_project/features/cards/data/models/flashcard_statistic_model.dart';
import 'package:basa_app_project/features/cards/domain/entities/time_consume_stats_entity.dart';
import 'package:basa_app_project/features/cards/domain/usecases/get_sidetitles_chart_usecase.dart';
import 'package:basa_app_project/features/cards/presentation/widgets/deck_graph_container.dart';
import 'package:basa_app_project/features/cards/presentation/widgets/time_consume_stats_header.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbols.dart';
import 'package:intl/intl.dart';
import 'package:m3e_core/m3e_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlayTimeStatsLayout extends StatefulWidget {
  const PlayTimeStatsLayout({
    super.key,

    required this.timeStats,
    required this.monthlyData,
    required this.weeklyData,
    required this.dailyData,
  });

  final TimeConsumeStatsEntity timeStats;
  final List<TimeConsumeStatsEntity> monthlyData;
  final List<TimeConsumeStatsEntity> weeklyData;
  final List<TimeConsumeStatsEntity> dailyData;

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
    final String _monthName = DateFormat.MMMM('en_US').format(_now);
    final int _year = _now.year;

    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
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
        SliverToBoxAdapter(
          child: Column(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                switchInCurve: Curves.easeIn,
                switchOutCurve: Curves.easeOut,
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: Text(
                  _selectedPage != 2 ? "$_monthName $_year" : "$_year",
                  key: ValueKey<int>(_selectedPage),
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge!.copyWith(fontSize: 40),
                ),
              ),
              Text(
                "Time Periodically Statistics",
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
                    "Visually served information of your accuracy for this deck.",
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
                height: 300.h,
                child: PageView(
                  physics: BouncingScrollPhysics(),
                  onPageChanged: (int pageIndex) => setState(() {
                    _selectedPage = pageIndex;
                  }),
                  controller: _pageController,
                  children: [
                    CallendarHeatmap(dailyData: widget.dailyData),
                    DeckGraphContainer(
                      data: widget.weeklyData,
                      getTitlesWidget: (double axisX, TitleMeta meta) {
                        return getWeeklyTitleByIndexFunction(
                          axisX: axisX,
                          meta: meta,
                        );
                      },
                      getYValue: (TimeConsumeStatsEntity item) =>
                          double.parse(item.totalTime.minutes),
                    ),
                    DeckGraphContainer<TimeConsumeStatsEntity>(
                      data: widget.monthlyData,
                      getTitlesWidget: (double axisX, TitleMeta meta) {
                        return getMonthlyTitleByIndexFunction(
                          axisX: axisX,
                          meta: meta,
                        );
                      },
                      getYValue: (TimeConsumeStatsEntity item) =>
                          double.parse(item.totalTime.minutes),
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
