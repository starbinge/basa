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
  final CardsDao cardsDao;
  final File filePath;
  final List<CardsDetailEntity>? searchResults;

  FetchingCardIsFinished({
    required this.cardsEntity,
    required this.cardsDao,
    required this.filePath,
    this.searchResults,
  });

  FetchingCardIsFinished copyWith({
    CardsEntity? cardsEntity,
    CardsDao? cardsDao,
    File? filePath,
    List<CardsDetailEntity>? searchResults,
  }) {
    return FetchingCardIsFinished(
      cardsEntity: cardsEntity ?? this.cardsEntity,
      cardsDao: cardsDao ?? this.cardsDao,
      filePath: filePath ?? this.filePath,
      searchResults: searchResults ?? this.searchResults,
    );
  }
}
