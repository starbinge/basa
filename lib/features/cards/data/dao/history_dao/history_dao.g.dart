// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_dao.dart';

// ignore_for_file: type=lint
mixin _$HistoryDaoMixin on DatabaseAccessor<ExternalDatabase> {
  $CardsTableTable get cardsTable => attachedDatabase.cardsTable;
  $NotesTableTable get notesTable => attachedDatabase.notesTable;
  $RevlogTableTable get revlogTable => attachedDatabase.revlogTable;
  HistoryDaoManager get managers => HistoryDaoManager(this);
}

class HistoryDaoManager {
  final _$HistoryDaoMixin _db;
  HistoryDaoManager(this._db);
  $$CardsTableTableTableManager get cardsTable =>
      $$CardsTableTableTableManager(_db.attachedDatabase, _db.cardsTable);
  $$NotesTableTableTableManager get notesTable =>
      $$NotesTableTableTableManager(_db.attachedDatabase, _db.notesTable);
  $$RevlogTableTableTableManager get revlogTable =>
      $$RevlogTableTableTableManager(_db.attachedDatabase, _db.revlogTable);
}
