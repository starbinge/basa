import 'package:basa_app_project/features/cards/presentation/widgets/statistics/shared/stats_header_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class AccuracyStatsHeader extends StatelessWidget {
  const AccuracyStatsHeader({
    super.key,
    required this.thisMonthStats,
    required this.previousMonthStats,
  });

  final int thisMonthStats;
  final int previousMonthStats;

  @override
  Widget build(BuildContext context) {
    final displayLarge = Theme.of(context).textTheme.displayLarge;
    final displayMedium = Theme.of(context).textTheme.displayMedium;
    final labelLarge = Theme.of(context).textTheme.labelLarge;
    final int difference = thisMonthStats - previousMonthStats;

    return StatsHeaderContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "$thisMonthStats",
                style: displayLarge?.copyWith(
                  fontSize: thisMonthStats == 100 ? 80.sp : 120.sp,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  height: 1.0,
                  letterSpacing: -2,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 12.h, left: 4.w),
                child: Text(
                  "%",
                  style: displayMedium?.copyWith(
                    fontSize: 60.sp,
                    fontWeight: FontWeight.w900,
                    color: Colors.white.withValues(alpha: 0.7),
                    height: 1.0,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: difference >= 0
                      ? Colors.green.withValues(alpha: 0.3)
                      : Colors.red.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(100.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      difference >= 0
                          ? Icons.arrow_upward_rounded
                          : Icons.arrow_downward_rounded,
                      color: Colors.white,
                      size: 16.sp,
                    ),
                    Text(
                      "${difference.abs()}%",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(100.r),
            ),
            child: Text(
              "ACCURACY THIS MONTH",
              style: labelLarge?.copyWith(
                color: Colors.white,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            spacing: 10,
            children: [
              const Icon(Icons.calendar_today_rounded, color: Colors.white),
              Text(
                "Last Check ${DateFormat.yMMMMd('en_US').format(DateTime.now())}",
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
