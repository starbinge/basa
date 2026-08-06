import 'package:drift/drift.dart';

class ImportedDeck extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get deckName => text()();

  TextColumn get deckLanguage => text().withLength(min: 1, max: 30)();

  TextColumn get countryDeck => text()();

  TextColumn get dbPath => text()();

  IntColumn get activeHour => integer().withDefault(const Constant(0))();

  TextColumn get filePath => text()();

  DateTimeColumn get importedDate =>
      dateTime().withDefault(Constant(DateTime.now()))();

  IntColumn get colorDeck => integer()();

  TextColumn get language => text()();

  TextColumn get rolePlay => text()();

  TextColumn get difficulty => text()();

  TextColumn get explanationRolePlay => text()();
}
