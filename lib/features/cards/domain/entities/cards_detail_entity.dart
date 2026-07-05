import 'audio_entity.dart';

class CardsDetailEntity {
  final int id;
  final int noteId;
  final int queue;
  final int reps;
  final int odue;
  final int ivl;
  final int left;
  final String defaultLanguage;
  final String translatedLanguage;
  final List<String> descriptions;
  final List<String> audioPath;
  final String? imagePath;
  final List<String>? tags;
  final int factor;

  CardsDetailEntity({
    required this.id,
    required this.noteId,
    required this.queue,
    required this.reps,
    required this.odue,
    required this.ivl,
    required this.defaultLanguage,
    required this.translatedLanguage,
    required this.descriptions,
    required this.audioPath,
    this.imagePath,
    this.tags,
    required this.factor,
    required this.left,
  });
}
