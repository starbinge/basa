import 'package:basa_app_project/core/constants/screen_size.dart';
import 'package:basa_app_project/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:m3e_core/m3e_core.dart';

class EndingGamePage extends StatelessWidget {
  const EndingGamePage({
    super.key,
    required this.totalAnswered,
    required this.isLate,
  });
  final int totalAnswered;
  final bool isLate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            child: Stack(
              alignment: AlignmentGeometry.center,
              children: [
                M3EShape.c9SidedCookie(
                      width: context.screenWidth * 0.3,
                      height: context.screenWidth * 0.3,
                      color: AppColors.tertiaryContainer,
                      border: BorderSide(width: 2, color: AppColors.tertiary),
                    )
                    .animate(onPlay: (controller) => controller.repeat())
                    .rotate(
                      duration: Duration(seconds: 5),
                      curve: Curves.linear,
                    ),
                Icon(
                  Icons.emoji_events_rounded,
                  size: 50,
                  color: AppColors.tertiaryDark,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            width: double.infinity / 2,
            child: Text(
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayMedium,
              isLate ? "You’re Doing Great!" : "Good Job!",
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            width: double.infinity / 2,
            child: Text(
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
              isLate
                  ? "Even tho you are late, it is good rather than not doing anything."
                  : "Every small step means everything for your journey. Keep trying!",
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(80.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 10,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
              ),
              itemBuilder: (BuildContext context, int indexItem) {
                return Center(
                  child: M3EShape.c9SidedCookie(
                    width: context.screenWidth * 0.1,
                    height: context.screenWidth * 0.1,

                    color: indexItem < totalAnswered
                        ? AppColors.tertiary
                        : AppColors.surfaceContainerHighest,
                  ),
                ).animate().scale(
                  curve: Curves.bounceOut,
                  delay: (Duration(milliseconds: indexItem * 200)),
                  duration: Duration(milliseconds: 800),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: M3EButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text(
                "Done",
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: Colors.white),
              ),
              size: M3EButtonSize.custom(width: double.infinity),
              decoration: M3EButtonDecoration(
                backgroundColor: WidgetStatePropertyAll(AppColors.primaryDark),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
