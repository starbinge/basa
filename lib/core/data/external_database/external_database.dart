import 'package:basa_app_project/features/cards/data/models/fetching_cards_model.dart';
import 'package:drift/drift.dart';

import '../../../features/cards/data/dao/cards_dao.dart';

part 'external_database.g.dart';

@DriftDatabase(tables: [CardsTable, NotesTable, RevlogTable], daos: [CardsDao])
class ExternalDatabase extends _$ExternalDatabase {
  ExternalDatabase(super.e);

  @override
  int get schemaVersion => 1;
}
