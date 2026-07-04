part of 'fetching_cards_bloc.dart';

@immutable
sealed class FetchingCardsEvent {}

class FetchCards extends FetchingCardsEvent {
  final int deckId;
  final String deckName;
  final String deckCountry;
  final File filePath;
  final String fileName;

  FetchCards({
    required this.deckId,
    required this.deckName,
    required this.deckCountry,
    required this.filePath,
    required this.fileName,
  });
}

class GetCardById extends FetchingCardsEvent {
  final int cardId;
  final CardRepo cardRepo;

  GetCardById({required this.cardId, required this.cardRepo});
}
