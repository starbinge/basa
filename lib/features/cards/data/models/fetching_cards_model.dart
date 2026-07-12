import 'package:basa_app_project/features/cards/data/utils/regex_checker.utils.dart';
import 'package:drift/drift.dart';

import '../../domain/entities/cards_detail_entity.dart';

//card model for the UI
class CardsModel implements Comparable<CardsModel> {
  final int id;
  final int noteId;
  final int queue;
  final int reps;
  final int odue;
  final int left;
  final int ivl;
  final String defaultLanguage;
  final String translatedLanguage;
  final List<String> descriptions;
  final List<String> audioPath;
  final String? imagePath;
  final List<String>? tags;
  final int factor;
  final int flags;

  CardsModel({
    required this.id,
    required this.noteId,
    required this.queue,
    this.tags,
    required this.reps,
    required this.odue,
    required this.ivl,
    required this.factor,
    required this.defaultLanguage,
    required this.translatedLanguage,
    required this.audioPath,
    this.imagePath,
    required this.descriptions,
    required this.left,
    required this.flags,
  });

  @override
  int compareTo(CardsModel other) {
    return queue.compareTo(other.queue);
  }

  factory CardsModel.fromMap(Map<String, dynamic> map) {
    final String rawFields = map['flds'] ?? "";
    //splitting raw Fields into array
    final List<String> fields = rawFields.split("\u001f");

    //Grouping only language related fields
    final List<String> textFields = fields
        .map((field) => cleanTotalHtml(field))
        .where((field) => field.isNotEmpty && !field.contains('highlights :'))
        .toList();

    //Taking only Default Language
    final String defaultLanguage = textFields.isNotEmpty ? textFields[0] : "";

    //Taking only translated Language
    final String translatedLanguage = textFields.length > 1
        ? textFields[1]
        : "";

    //Taking additional explanations
    final List<String> descriptions = textFields.length > 2
        ? textFields.sublist(2)
        : [];

    //Taking only Audio Path
    final List<String> audioPath = extractAudios(fields: fields);

    //Taking only Image Path
    final String imagePath = extractImage(fields: fields) ?? "";

    //Taking only tags
    final String rawTags = map['tags'] ?? "";
    final List<String> tags = rawTags
        .split(" ")
        .where((tag) => tag.isNotEmpty)
        .toList();

    //Returning value
    return CardsModel(
      flags: map['flags'] ?? 0,
      id: map['card_id'] ?? map['id'] ?? 0,
      noteId: map['nid'] ?? 0,
      queue: map['queue'] ?? 0,
      tags: tags,
      reps: map['reps'] ?? 0,
      odue: map['odue'] ?? 0,
      left: map['left'] ?? 0,
      ivl: map['ivl'] ?? 0,
      factor: map['factor'] ?? 0,
      defaultLanguage: defaultLanguage,
      translatedLanguage: translatedLanguage,
      audioPath: audioPath,
      imagePath: imagePath,
      descriptions: descriptions,
    );
  }

  CardsDetailEntity toEntity() {
    return CardsDetailEntity(
      id: id,
      noteId: noteId,
      queue: queue,
      reps: reps,
      odue: odue,
      ivl: ivl,
      defaultLanguage: defaultLanguage,
      translatedLanguage: translatedLanguage,
      descriptions: descriptions,
      audioPath: audioPath,
      factor: factor,
      left: left,
      flags: flags,
    );
  }
}

// Model for Revlog UI
class RevlogModel {
  final int id;

  final int cid;

  final int ease;

  final int factor;

  final int time;

  RevlogModel({
    required this.id,
    required this.cid,
    required this.ease,
    required this.factor,
    required this.time,
  });

  factory RevlogModel.fromMap(Map<String, dynamic> map) {
    return RevlogModel(
      id: map['id'],
      cid: map['cid'],
      ease: map['ease'],
      factor: map['factor'],
      time: map['time'],
    );
  }
}

//model card for drift
class CardsTable extends Table {
  IntColumn get queue => integer()();

  IntColumn get id => integer()();

  IntColumn get nid => integer()();

  IntColumn get reps => integer()();

  IntColumn get factor => integer()();

  IntColumn get ivl => integer()();

  IntColumn get odue => integer()();

  IntColumn get left => integer()();

  IntColumn get flags => integer()();

  @override
  String get tableName => 'cards';

  @override
  Set<Column> get primaryKey => {id};
}

//model notes for drift
class NotesTable extends Table {
  IntColumn get id => integer()();

  TextColumn get flds => text()();

  IntColumn get mid => integer()();

  TextColumn get tags => text()();

  @override
  String get tableName => 'notes';
}

class RevlogTable extends Table {
  IntColumn get id => integer()();

  IntColumn get cid => integer()();

  IntColumn get usn => integer()();

  IntColumn get ease => integer()();

  IntColumn get ivl => integer()();

  IntColumn get lastIvl => integer().named('lastIvl')();

  IntColumn get factor => integer()();

  IntColumn get time => integer()();

  IntColumn get type => integer()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  String get tableName => 'revlog';
}
