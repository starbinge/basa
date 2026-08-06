part of 'fetching_cards_bloc.dart';

@immutable
sealed class FetchingCardsEvent {}

class FetchCards extends FetchingCardsEvent {
  final int deckId;
  final String deckName;
  final String deckCountry;
  final String dbPath;

  FetchCards({
    required this.deckId,
    required this.deckName,
    required this.deckCountry,
    required this.dbPath,
  });
}

class SearchCard extends FetchingCardsEvent {
  final String searchParams;

  SearchCard({required this.searchParams});
}
