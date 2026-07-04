part of 'fetching_cards_bloc.dart';

@immutable
sealed class FetchingCardsState {}

final class FetchingCardInitial extends FetchingCardsState {}

final class FetchingCardIsLoading extends FetchingCardsState {}

final class FetchingCardIsError extends FetchingCardsState {
  final String errorMessage;

  FetchingCardIsError({required this.errorMessage});
}

final class FetchingCardIsFinished extends FetchingCardsState {
  final CardsEntity cardsEntity;

  FetchingCardIsFinished({required this.cardsEntity});
}
