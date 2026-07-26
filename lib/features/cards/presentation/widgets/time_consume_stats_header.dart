import 'package:basa_app_project/core/theme/app_colors.dart';
import 'package:basa_app_project/features/cards/presentation/widgets/layouts/play_time_stats_layout.dart';
import 'package:basa_app_project/features/cards/presentation/widgets/stats_header_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TimeConsumeStatsHeader extends StatelessWidget {
  const TimeConsumeStatsHeader({
    super.key,
    required this.widget,
    required this.displayLarge,
    required this.displayMedium,
    required this.headlineSmall,
    required this.labelLarge,
  });

  final PlayTimeStatsLayout widget;
  final TextStyle? displayLarge;
  final TextStyle? displayMedium;
  final TextStyle? headlineSmall;
  final TextStyle? labelLarge;

  @override
  Widget build(BuildContext context) {
    return StatsHeaderContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.timeStats.totalTime.hour.toString().padLeft(2, '0'),
                style: displayLarge?.copyWith(
                  fontSize: 120.sp,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  height: 1.0,
                  letterSpacing: -2,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8.h, left: 4.w),
                child: Text(
                  ":",
                  style: displayMedium?.copyWith(
                    fontSize: 80.sp,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primaryLight,
                    height: 1.0,
                  ),
                ),
              ),
              Text(
                widget.timeStats.totalTime.minute.toString().padLeft(2, '0'),
                style: displayMedium?.copyWith(
                  fontSize: 60.sp,
                  fontWeight: FontWeight.w800,
                  color: Colors.white.withValues(alpha: 0.9),
                  height: 1.0,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 6.h, left: 4.w),
                child: Text(
                  widget.timeStats.totalTime.seconds.toString().padLeft(2, '0'),
                  style: headlineSmall?.copyWith(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withValues(alpha: 0.6),
                    height: 1.0,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(100.r),
            ),
            child: Text(
              "TOTAL TIME SPENT",
              style: labelLarge?.copyWith(
                color: Colors.white,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            spacing: 10,
            children: [
              Icon(Icons.timer_rounded, color: Colors.white),
              Text(
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.white),
                "Average Per Card: ${widget.timeStats.avgTime.minute} m ${widget.timeStats.avgTime.seconds} s ",
              ),
            ],
          ),
        ],
      ),
    );
  }
}
