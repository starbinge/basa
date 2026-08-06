import 'package:basa_app_project/core/theme/app_colors.dart';
import 'package:basa_app_project/core/widgets/animated_header.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';
import 'package:flutter/material.dart';

class WrongAnswerBottombar extends StatelessWidget {
  const WrongAnswerBottombar({
    super.key,
    required this.selectedCard,
    required this.textButtonPressed,
  });

  final CardsDetailEntity? selectedCard;
  final VoidCallback textButtonPressed;

  double _dynamicFontSize(String text) {
    final int length = text.length;
    if (length <= 10) return 48;
    if (length <= 20) return 36;
    if (length <= 30) return 28;
    if (length <= 50) return 22;
    return 18;
  }

  @override
  Widget build(BuildContext context) {
    final String translatedText = selectedCard?.translatedLanguage ?? "";
    final String defaultText = selectedCard?.defaultLanguage ?? "";

    return Container(
      decoration: BoxDecoration(
        color: AppColors.errorContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      width: double.infinity,
      height: 500,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "Wrong Answer",
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: AppColors.error),
          ),
          if (selectedCard == null)
            const AnimatedHeader(
              icon: Icons.hourglass_empty_rounded,
              title: "Cards Not Found",
              subtitle: "Something is wrong with the card.",
            ),

          Column(
            children: [
              Text(
                translatedText,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: AppColors.error,
                  fontSize: _dynamicFontSize(translatedText),
                ),
              ),
              Text(
                defaultText,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.error,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: textButtonPressed,
            child: const Text("Yes, I understood!"),
            style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(AppColors.error),
              foregroundColor: WidgetStatePropertyAll(AppColors.errorContainer),
            ),
          ),
        ],
      ),
    );
  }
}
