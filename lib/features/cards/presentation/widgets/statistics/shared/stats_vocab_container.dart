import 'package:basa_app_project/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:m3e_core/m3e_core.dart';

class StatsVocabContainer extends StatelessWidget {
  const StatsVocabContainer({
    super.key,
    required this.translatedLanguage,
    required this.defaultLanguage,
    required this.numberIndicator,
    required this.title,
  });

  final String translatedLanguage;
  final String defaultLanguage;
  final String numberIndicator;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(width: 1, color: Colors.grey.withValues(alpha: 0.3)),
      ),
      child: ListTile(
        title: Text(
          translatedLanguage,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(defaultLanguage),
        trailing: title.contains("Time")
            ? Stack(
                alignment: AlignmentGeometry.center,
                children: [
                  M3EShape.c9SidedCookie(
                    height: 50,
                    width: 50,
                    color: AppColors.tertiary.withValues(alpha: 0.4),
                  ),
                  Text(
                    numberIndicator.toString(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.tertiary,
                    ),
                  ),
                ],
              )
            : null,
      ),
    );
  }
}
