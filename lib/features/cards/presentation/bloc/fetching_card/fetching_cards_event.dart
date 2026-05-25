part of 'fetching_cards_bloc.dart';

@immutable
sealed class FetchingCardsEvent {}

class FetchCards extends FetchingCardsEvent {
  final int deckId;

  FetchCards({required this.deckId});
}
