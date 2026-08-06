class DeckEntity {
  int id;

  String deckName;

  String deckLanguage;

  String countryDeck;

  String dbPath;

  int activeHour;

  String extractedPath;

  DateTime importedDate;

  int deckColor;

  String language;

  String rolePlay;

  String difficulty;

  String explanationRolePlay;

  DeckEntity({
    required this.deckColor,
    required this.id,
    required this.deckName,
    required this.activeHour,
    required this.deckLanguage,
    required this.extractedPath,
    required this.importedDate,
    this.countryDeck = "",
    this.dbPath = "",
    this.language = "",
    this.rolePlay = "",
    this.difficulty = "",
    this.explanationRolePlay = "",
  });
}
