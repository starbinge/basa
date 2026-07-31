// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_consume_dao.dart';

// ignore_for_file: type=lint
mixin _$TimeConsumeDaoMixin on DatabaseAccessor<ExternalDatabase> {
  $CardsTableTable get cardsTable => attachedDatabase.cardsTable;
  $NotesTableTable get notesTable => attachedDatabase.notesTable;
  $RevlogTableTable get revlogTable => attachedDatabase.revlogTable;
  TimeConsumeDaoManager get managers => TimeConsumeDaoManager(this);
}

class TimeConsumeDaoManager {
  final _$TimeConsumeDaoMixin _db;
  TimeConsumeDaoManager(this._db);
  $$CardsTableTableTableManager get cardsTable =>
      $$CardsTableTableTableManager(_db.attachedDatabase, _db.cardsTable);
  $$NotesTableTableTableManager get notesTable =>
      $$NotesTableTableTableManager(_db.attachedDatabase, _db.notesTable);
  $$RevlogTableTableTableManager get revlogTable =>
      $$RevlogTableTableTableManager(_db.attachedDatabase, _db.revlogTable);
}
