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
  final List<DeckTimeConsume> weeklyTimeConsumeData;
  final DeckAccuracy thisMonthAccuracyNumber;
  final DeckAccuracy previousMonthAccuracyNumber;

  FetchingCardIsFinished({
    required this.cardsEntity,
    required this.cardsDao,
    required this.filePath,
    required this.weeklyTimeConsumeData,
    required this.thisMonthAccuracyNumber,
    required this.previousMonthAccuracyNumber,
  });
}
