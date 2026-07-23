import 'package:basa_app_project/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class OptionButton extends StatelessWidget {
  const OptionButton({
    super.key,
    required this.option,
    required this.correctAnswer,
    required this.onTap,
    required this.indexOption,
    required this.indexCorrectOption,
    required this.selectedIndex,
  });

  final String option;
  final String correctAnswer;
  final VoidCallback onTap;
  final int indexOption;
  final int indexCorrectOption;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    final bool hasAnswered = selectedIndex != -1;

    Color backgroundColor = AppColors.inversePrimary;
    Color textColor = AppColors.primaryDark;
    double padding = 10;

    if (hasAnswered) {
      if (indexOption == indexCorrectOption) {
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade800;

        if (indexOption == selectedIndex) {
          padding = 20;
        } else {
          padding = 10;
        }
      } else if (indexOption == selectedIndex) {
        backgroundColor = AppColors.errorContainer;
        textColor = AppColors.error;
        padding = 20;
      }
    }

    return GestureDetector(
      onTap: hasAnswered ? null : onTap,
      child: AnimatedContainer(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: padding),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: backgroundColor,
        ),
        width: double.infinity,
        curve: Curves.bounceOut,
        duration: const Duration(milliseconds: 500),
        child: Center(
          child: Text(
            option,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
