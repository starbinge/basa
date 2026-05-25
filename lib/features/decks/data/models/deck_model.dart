import 'package:drift/drift.dart';

class ImportedDeck extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get deckName => text()();

  TextColumn get deckLanguage => text().withLength(min: 1, max: 30)();

  IntColumn get activeHour => integer().withDefault(const Constant(0))();

  TextColumn get apkgPath => text()();

  TextColumn get extractedPath => text()();

  DateTimeColumn get importedDate =>
      dateTime().withDefault(Constant(DateTime.now()))();

  IntColumn get colorDeck => integer()();
}
