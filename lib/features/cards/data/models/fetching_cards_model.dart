import 'package:drift/drift.dart';

class CardsTable extends Table {
  IntColumn get nid => integer()();
  IntColumn get reps => integer()();
  IntColumn get factor => integer()();
}
class NotesTable extends Table {
  IntColumn get id => integer()();
  TextColumn get flds => text()();
}