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
  final int flags;

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
    required this.flags,
  });

  factory CardsDetailEntity.fromMap(Map<String, dynamic> map) =>
      CardsDetailEntity(
        id: map['id'] as int,
        noteId: map['noteId'] as int,
        queue: map['queue'] as int,
        reps: map['reps'] as int,
        odue: map['odue'] as int,
        ivl: map['ivl'] as int,
        left: map['left'] as int,
        defaultLanguage: map['defaultLanguage'] as String,
        translatedLanguage: map['translatedLanguage'] as String,
        descriptions: (map['descriptions'] as List).cast<String>(),
        audioPath: (map['audioPath'] as List).cast<String>(),
        imagePath: map['imagePath'] as String?,
        tags: (map['tags'] as List?)?.cast<String>(),
        factor: map['factor'] as int,
        flags: map['flags'] as int,
      );

  Map<String, dynamic> toMap() => {
    'id': id,
    'noteId': noteId,
    'queue': queue,
    'reps': reps,
    'odue': odue,
    'ivl': ivl,
    'left': left,
    'defaultLanguage': defaultLanguage,
    'translatedLanguage': translatedLanguage,
    'descriptions': descriptions,
    'audioPath': audioPath,
    'imagePath': imagePath,
    'tags': tags,
    'factor': factor,
    'flags': flags,
  };
}
