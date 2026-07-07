import 'package:basa_app_project/core/constants/common_path.dart';
import 'package:basa_app_project/core/utils/custom_deck__color_mapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DeckContainer extends StatelessWidget {
  const DeckContainer({
    super.key,
    required this.indexDeck,
    required this.deckName,
    required this.deckLanguage,
    required this.iconColor,
  });

  final int indexDeck;
  final String deckName;
  final String deckLanguage;
  final int iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              height: 60,
              imagePath + "folder_icon(1).svg",
              colorMapper: CustomDeckColorMapper(selectedColor: iconColor),
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                deckName,
                textAlign: TextAlign.center,
                style: theme.textTheme.labelMedium,
              ),
            ),
            Text(
              deckLanguage,
              textAlign: TextAlign.center,
              style: theme.textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }
}
