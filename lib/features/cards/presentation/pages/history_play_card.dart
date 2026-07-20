import 'package:basa_app_project/features/cards/domain/entities/card_history_entity.dart';
import 'package:basa_app_project/features/cards/presentation/widgets/vocab_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:m3e_core/m3e_core.dart';

class HistoryPlayCard extends StatelessWidget {
  const HistoryPlayCard({super.key, required this.cardHistoryEntity});
  final CardHistoryEntity cardHistoryEntity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(),
          SliverMainAxisGroup(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  constraints: BoxConstraints(maxHeight: 250),
                  child: Column(
                    spacing: 20,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: AlignmentGeometry.center,
                        children: [
                          M3EShape.c9SidedCookie(
                                width: 100,
                                height: 100,
                                color: Theme.of(context).primaryColorDark,
                              )
                              .animate(
                                onComplete: (controller) => controller.repeat(),
                              )
                              .rotate(
                                duration: Duration(seconds: 5),
                                curve: Curves.linear,
                              ),
                          Icon(Icons.history, size: 50, color: Colors.white),
                        ],
                      ),
                      Text(
                        "History",
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      Text(
                        "We try to keep your memories, as much as we can.",
                        style: Theme.of(
                          context,
                        ).textTheme.labelLarge?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsetsGeometry.all(10),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    spacing: 20,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Today History",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: BoxBorder.all(
                            width: 0.5,
                            color: Colors.grey.withValues(alpha: 0.3),
                          ),
                        ),
                        constraints: BoxConstraints(maxHeight: 400),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: cardHistoryEntity.todayHistory.length,
                          itemBuilder: ((context, indexItem) {
                            return VocabCard(
                              listCard: cardHistoryEntity.todayHistory,
                              index: indexItem,
                              playButtonPressed: () {},
                              onLongPressed: () {},
                              onCardTap: () {},
                            );
                          }),
                        ),
                      ),
                      Text(
                        "This Week History",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: BoxBorder.all(
                            width: 0.5,
                            color: Colors.grey.withValues(alpha: 0.3),
                          ),
                        ),
                        constraints: BoxConstraints(maxHeight: 400),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: cardHistoryEntity.weeklyHistory.length,
                          itemBuilder: ((context, indexItem) {
                            return VocabCard(
                              listCard: cardHistoryEntity.weeklyHistory,
                              index: indexItem,
                              playButtonPressed: () {},
                              onLongPressed: () {},
                              onCardTap: () {},
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
