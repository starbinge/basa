import 'package:basa_app_project/features/cards/domain/entities/cards_entity.dart';
import 'package:basa_app_project/features/cards/presentation/bloc/fetching_card/fetching_cards_bloc.dart';
import 'package:basa_app_project/features/cards/presentation/widgets/flash_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainCardPage extends StatefulWidget {
  const MainCardPage({super.key, required this.deckId});

  final int deckId;

  @override
  State<MainCardPage> createState() => _MainCardPageState();
}

class _MainCardPageState extends State<MainCardPage> {
  @override
  void initState() {
    super.initState();
    context.read<FetchingCardsBloc>().add(FetchCards(deckId: widget.deckId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchingCardsBloc, FetchingCardsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              state is FetchingCardIsFinished
                  ? state.cardsEntity.deckName
                  : '',
            ),
          ),
          body: switch (state) {
            FetchingCardsInitial() || FetchingCardIsLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            FetchingCardIsFinished(:final cardsEntity) =>
              _buildCardList(cardsEntity),
            FetchingCardIsError(:final errorMessage) => Center(
              child: Text(errorMessage),
            ),
          },
        );
      },
    );
  }

  Widget _buildCardList(CardsEntity cardsEntity) {
    if (cardsEntity.listCard.isEmpty) {
      return const Center(child: Text('No cards in this deck'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: cardsEntity.listCard.length,
      itemBuilder: (context, index) {
        return FlashCardWidget(card: cardsEntity.listCard[index]);
      },
    );
  }
}
