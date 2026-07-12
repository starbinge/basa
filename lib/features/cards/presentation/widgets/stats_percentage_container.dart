import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/screen_size.dart';

class StatsPercentageContainer extends StatelessWidget {
  const StatsPercentageContainer({
    super.key,
    required int thisMonthStats,
    required int previousMonthStats,
    required String titleCards,
    required IconData backgroundIcon,
    required Color backgroundColor,
  }) : _backgroundIcon = backgroundIcon,
       _backgroundColor = backgroundColor,
       _titleCards = titleCards,
       _thisMonthStats = thisMonthStats,
       _previousMonthStats = previousMonthStats;

  final int _thisMonthStats;
  final int _previousMonthStats;
  final String _titleCards;
  final IconData _backgroundIcon;
  final Color _backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      constraints: BoxConstraints(maxHeight: 200),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          Icon(
            _backgroundIcon,
            color: Colors.white.withValues(alpha: 0.1),
            size: TextTheme.of(context).displayLarge!.fontSize! * 5,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_titleCards}',
                    style: TextStyle(
                      fontSize: Theme.of(
                        context,
                      ).textTheme.titleMedium?.fontSize,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    padding: EdgeInsetsGeometry.symmetric(
                      vertical: 2,
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          (_thisMonthStats - _previousMonthStats) < 0
                              ? Icons.arrow_downward
                              : Icons.arrow_upward_sharp,
                          color: Colors.white,
                          size: TextTheme.of(context).titleMedium?.fontSize,
                        ),
                        Text(
                          '${_thisMonthStats - _previousMonthStats}',
                          style: TextStyle(
                            fontSize: TextTheme.of(
                              context,
                            ).titleMedium?.fontSize,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Text(
                '${_thisMonthStats}%',
                style: TextStyle(
                  fontSize: (Theme.of(
                    context,
                  ).textTheme.displayLarge!.fontSize!),
                  color: Colors.white,
                ),
              ),

              SizedBox(height: 10),
              Text(
                "Last Check ${DateFormat.yMMMMd('en_US').format(DateTime.now())}",
                style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
