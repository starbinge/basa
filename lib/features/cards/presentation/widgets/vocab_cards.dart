import 'package:basa_app_project/core/widgets/animated_play_pause_button.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/cards_detail_entity.dart';

class VocabCard extends StatelessWidget {
  const VocabCard({
    super.key,
    required this.listCard,
    required this.index,
    required this.isPlaying,
    required this.playButtonPressed,
    required this.pauseButtonPressed,
    required this.onLongPressed,
    required this.onCardTap,
  });

  final List<CardsDetailEntity> listCard;
  final int index;
  final bool isPlaying;
  final VoidCallback playButtonPressed;
  final VoidCallback pauseButtonPressed;
  final VoidCallback onLongPressed;
  final VoidCallback onCardTap;

  @override
  Widget build(BuildContext context) {
    final bool hasAudio =
        listCard[index].audioPath.isNotEmpty &&
        listCard[index].audioPath.first.isNotEmpty;

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.symmetric(vertical: 2),
      color: Theme.of(context).canvasColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(5),
      ),
      borderOnForeground: false,
      elevation: 2.0,
      shadowColor: Theme.of(context).disabledColor.withAlpha(30),
      child: ListTile(
        onTap: onCardTap,
        onLongPress: onLongPressed,
        splashColor: Theme.of(context).primaryColor.withAlpha(100),
        title: Text(
          listCard[index].defaultLanguage,
          style: TextStyle(
            color: Theme.of(context).primaryColorDark,
            fontWeight: FontWeight.bold,
            fontSize: TextTheme.of(context).titleLarge?.fontSize,
          ),
        ),
        subtitle: Text(
          listCard[index].translatedLanguage,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        leading: hasAudio
            ? AnimatedPlayPauseButton(
                isPlaying: isPlaying,
                onPressed: isPlaying ? pauseButtonPressed : playButtonPressed,
                color: Theme.of(context).primaryColor,
              )
            : null,
      ),
    );
  }
}
