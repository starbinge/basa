import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/cards/domain/usecases/format_time_usecase.dart';
import '../theme/app_colors.dart';

class TimerContainer extends StatefulWidget {
  const TimerContainer({
    super.key,
    required this.time,
    required this.totalAnswered,
  });

  final int time;
  final int totalAnswered;

  @override
  State<TimerContainer> createState() => _TimerContainerState();
}

class _TimerContainerState extends State<TimerContainer> {
  int timeLeft = 0;
  Timer? _timer;

  @override
  void initState() {
    setState(() {
      timeLeft = widget.time;
    });
    onPlay();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.inversePrimary.withValues(alpha: 0.3),
      ),
      child: Row(
        spacing: 8,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.alarm_rounded,
            color: AppColors.primaryDark,
            size: 18,
          ),
          Text(
            FormatTimeUseCase().timeDividerFromSeconds(
              durations: timeLeft.toString(),
            ),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.onPrimaryContainer,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  void onPlay() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft <= 0) {
        _timer?.cancel();
        if (mounted) {
          context.push(
            '/stats-quiz-game',
            extra: (totalAnswered: widget.totalAnswered, isLate: true),
          );
        }
      }
      setState(() {
        timeLeft--;
      });
    });
  }
}
