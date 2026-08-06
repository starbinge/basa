class CardsDetailEntity {
  final int id;
  final String defaultLanguage;
  final String translatedLanguage;
  final String additionalContext;
  final String pronunciation;

  CardsDetailEntity({
    required this.id,
    required String defaultLanguage,
    required String translatedLanguage,
    required this.additionalContext,
    required this.pronunciation,
  }) : defaultLanguage = defaultLanguage.replaceAll(RegExp(r'\{|\}'), '').trim(),
       translatedLanguage = translatedLanguage.replaceAll(RegExp(r'\{|\}'), '').trim();
}
