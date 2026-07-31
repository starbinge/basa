import 'package:basa_app_project/core/theme/app_colors.dart';
import 'package:basa_app_project/core/widgets/animated_header.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';
import 'package:flutter/material.dart';

import '../shared/vocab_cards.dart';

class HistoryContainer extends StatefulWidget {
  const HistoryContainer({
    super.key,
    required this.timeLabel,
    required this.listCard,
  });

  final String timeLabel;
  final List<CardsDetailEntity> listCard;

  @override
  State<HistoryContainer> createState() => _HistoryContainerState();
}

class _HistoryContainerState extends State<HistoryContainer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        spacing: 20,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.timeLabel, style: Theme.of(context).textTheme.titleLarge),
          widget.listCard.isEmpty
              ? AnimatedHeader(icon: Icons.hourglass_empty)
              : Container(
                  constraints: BoxConstraints(maxHeight: 400),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 0.5,
                      color: AppColors.outline.withValues(alpha: 0.4),
                    ),
                  ),
                  child: ListView.builder(
                    itemCount: widget.listCard.length,
                    shrinkWrap: true,
                    itemBuilder: (context, itemIndex) {
                      return VocabCard(
                        listCard: widget.listCard,
                        index: itemIndex,
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
