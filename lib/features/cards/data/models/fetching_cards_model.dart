import 'package:drift/drift.dart';

//card model for the UI

class CardsModel {
  final int id;
  final int noteId;
  final int queue;
  final List<String> fields;
  final List<String> tags;

  CardsModel({
    required this.id,
    required this.noteId,
    required this.queue,
    required this.fields,
    required this.tags,
  });

  factory CardsModel.fromMap(Map<String, dynamic> map) {
    final String rawFields = map['flds'] ?? "";
    final List<String> fields = rawFields.split("\u001f");
    final String rawTags = map['tags'] ?? "";
    final List<String> tags = rawTags
        .split(" ")
        .where((tag) => tag.isNotEmpty)
        .toList();
    return CardsModel(
      id: map['card_id'] ?? map['id'] ?? 0,
      noteId: map['nid'] ?? 0,
      queue: map['queue'] ?? 0,
      fields: fields,
      tags: tags,
    );
  }

  String get defaultLanguage => fields.length > 1 ? fields[0] : '';

  String get translatedLanguage => fields.length > 1 ? fields[1] : '';
}

//model card for drift
class CardsTable extends Table {
  IntColumn get queue => integer()();

  IntColumn get id => integer()();

  IntColumn get nid => integer()();

  IntColumn get reps => integer()();

  IntColumn get factor => integer()();

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
