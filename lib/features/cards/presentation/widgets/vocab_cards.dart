import 'package:flutter/material.dart';

import '../../domain/entities/cards_detail_entity.dart';

class VocabCard extends StatelessWidget {
  const VocabCard({
    super.key,
    required this.listCard,
    required this.index,
    required this.playButtonPressed,
    required this.onLongPressed,
    required this.onCardTap,
  });

  final List<CardsDetailEntity> listCard;
  final int index;
  final VoidCallback playButtonPressed;
  final VoidCallback onLongPressed;
  final VoidCallback onCardTap;

  @override
  Widget build(BuildContext context) {
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
        titleTextStyle: TextStyle(
          color: Theme.of(context).primaryColorDark,
          fontWeight: FontWeight.bold,
          fontSize: TextTheme.of(context).titleLarge?.fontSize,
        ),
        title: Text(listCard[index].defaultLanguage),
        subtitle: Text(listCard[index].translatedLanguage),
        leading: IconButton(
          splashColor: Theme.of(context).primaryColor,
          onPressed: playButtonPressed,
          icon: Icon(Icons.play_arrow),
        ),
      ),
    );
  }
}
