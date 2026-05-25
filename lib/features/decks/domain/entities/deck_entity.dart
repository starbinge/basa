class DeckEntity {
  int id;

  String deckName;

  String deckLanguage;

  int activeHour;

  String apkgPath;

  String extractedPath;

  DateTime importedDate;

  int deckColor;

  DeckEntity({
    required this.deckColor,
    required this.id,
    required this.deckName,
    required this.activeHour,
    required this.apkgPath,
    required this.deckLanguage,
    required this.extractedPath,
    required this.importedDate,
  });
}
