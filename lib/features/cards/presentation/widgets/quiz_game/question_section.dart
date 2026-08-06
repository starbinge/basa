import 'package:basa_app_project/core/constants/screen_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:m3e_core/m3e_core.dart';

import '../../../../../core/theme/app_colors.dart';

class QuestionSection extends StatelessWidget {
  const QuestionSection({
    super.key,
    required this.activeQuestion,
    required this.question,
  });

  final int activeQuestion;
  final String question;

  @override
  Widget build(BuildContext context) {
    double screenWidth = context.screenWidth;
    double cookieSize = (screenWidth * 0.65).clamp(200.0, 260.0);

    return Padding(
          key: ValueKey<int>(activeQuestion),
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          child: SizedBox(
            width: cookieSize,
            height: cookieSize,
            child: Stack(
              alignment: Alignment.center,
              children: [
                M3EShape.c9SidedCookie(
                      width: cookieSize,
                      height: cookieSize,
                      color: AppColors.inversePrimary.withValues(alpha: 0.2),
                    )
                    .animate(onComplete: (controller) => controller.repeat())
                    .rotate(
                      curve: Curves.linear,
                      duration: const Duration(seconds: 5),
                    ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Text(
                        question,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              color: AppColors.primaryDark,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
        .animate(key: ValueKey<int>(activeQuestion))
        .scale(
          curve: Curves.fastEaseInToSlowEaseOut,
          duration: const Duration(milliseconds: 300),
        );
  }
}
