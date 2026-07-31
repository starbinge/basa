// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accuracy_dao.dart';

// ignore_for_file: type=lint
mixin _$AccuracyDaoMixin on DatabaseAccessor<ExternalDatabase> {
  $CardsTableTable get cardsTable => attachedDatabase.cardsTable;
  $NotesTableTable get notesTable => attachedDatabase.notesTable;
  $RevlogTableTable get revlogTable => attachedDatabase.revlogTable;
  AccuracyDaoManager get managers => AccuracyDaoManager(this);
}

class AccuracyDaoManager {
  final _$AccuracyDaoMixin _db;
  AccuracyDaoManager(this._db);
  $$CardsTableTableTableManager get cardsTable =>
      $$CardsTableTableTableManager(_db.attachedDatabase, _db.cardsTable);
  $$NotesTableTableTableManager get notesTable =>
      $$NotesTableTableTableManager(_db.attachedDatabase, _db.notesTable);
  $$RevlogTableTableTableManager get revlogTable =>
      $$RevlogTableTableTableManager(_db.attachedDatabase, _db.revlogTable);
}
