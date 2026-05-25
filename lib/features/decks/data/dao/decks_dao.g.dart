// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'decks_dao.dart';

// ignore_for_file: type=lint
mixin _$DecksDaoMixin on DatabaseAccessor<AppDatabase> {
  $ImportedDeckTable get importedDeck => attachedDatabase.importedDeck;
  DecksDaoManager get managers => DecksDaoManager(this);
}

class DecksDaoManager {
  final _$DecksDaoMixin _db;
  DecksDaoManager(this._db);
  $$ImportedDeckTableTableManager get importedDeck =>
      $$ImportedDeckTableTableManager(_db.attachedDatabase, _db.importedDeck);
}
