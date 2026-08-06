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
  final GeneratedDeckDao generatedDeckDao;
  final List<CardsDetailEntity>? searchResults;

  FetchingCardIsFinished({
    required this.cardsEntity,
    required this.generatedDeckDao,
    this.searchResults,
  });

  FetchingCardIsFinished copyWith({
    CardsEntity? cardsEntity,
    GeneratedDeckDao? generatedDeckDao,
    List<CardsDetailEntity>? searchResults,
  }) {
    return FetchingCardIsFinished(
      cardsEntity: cardsEntity ?? this.cardsEntity,
      generatedDeckDao: generatedDeckDao ?? this.generatedDeckDao,
      searchResults: searchResults ?? this.searchResults,
    );
  }
}
