import 'package:basa_app_project/features/cards/presentation/widgets/shared/vocab_bottom_modal.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/cards_detail_entity.dart';

class VocabCard extends StatelessWidget {
  const VocabCard({super.key, required this.listCard, required this.index});

  final List<CardsDetailEntity> listCard;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(vertical: 2),
      color: Theme.of(context).canvasColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(5),
      ),
      borderOnForeground: false,
      elevation: 2.0,
      shadowColor: Theme.of(context).disabledColor.withAlpha(30),
      child: ListTile(
        onTap: () => whenCardTap(context),
        onLongPress: () {},
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
      ),
    );
  }

  void whenCardTap(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return VocabBottomModal(
          listCard: listCard,
          cardIndex: index,
        );
      },
    );
  }
}
