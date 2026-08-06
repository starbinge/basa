import 'dart:convert';
import 'dart:io';

import 'package:basa_app_project/core/data/generated_database/generated_database.dart';
import 'package:basa_app_project/core/data/initial_database/initial_database.dart';
import 'package:basa_app_project/core/errors/input_errors.dart';
import 'package:basa_app_project/features/decks/data/repositories/deck_repository_impl.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

class _FakePathProviderPlatform extends PathProviderPlatform {
  _FakePathProviderPlatform(this.documentsPath);

  final String documentsPath;

  @override
  Future<String?> getApplicationDocumentsPath() async => documentsPath;
}

void main() {
  late Directory tempDir;
  late File euyFile;
  late AppDatabase db;
  late DeckRepositoryImpl repo;

  setUp(() async {
    tempDir = Directory.systemTemp.createTempSync('import_deck_test');
    PathProviderPlatform.instance = _FakePathProviderPlatform(tempDir.path);

    euyFile = File(path.join(tempDir.path, 'sample.euy'));
    await euyFile.writeAsString(
      jsonEncode({
        'language': 'Korean',
        'countryDeck': 'KR',
        'rolePlay': 'A Student',
        'explanationRolePlay': 'From file explanation',
        'difficulty': 'beginner',
        'listCards': [
          {
            'defaultLanguage': 'anjing',
            'translation': 'dog',
            'additionalContext': '',
            'pronunciation': '',
          },
          {
            'defaultLanguage': 'kucing',
            'translation': 'cat',
            'additionalContext': '',
            'pronunciation': '',
          },
        ],
      }),
    );

    db = AppDatabase(NativeDatabase.memory());
    repo = DeckRepositoryImpl(decksDao: db.decksDao);
  });

  tearDown(() async {
    await db.close();
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  test('importDeck copies euy, builds sqlite, and stores metadata', () async {
    await repo.importDeck(
      deckName: 'Animal',
      deckFilePath: euyFile.path,
      deckColor: 123,
      deckLanguage: 'ID',
      explanationRolePlay: 'User explanation',
    );

    expect(
      File(path.join(tempDir.path, 'dotEuy', 'Animal.euy')).existsSync(),
      isTrue,
    );

    final decks = await db.decksDao.getAll();
    expect(decks, hasLength(1));
    final deck = decks.first;
    expect(deck.deckName, 'Animal');
    expect(deck.deckLanguage, 'ID');
    expect(deck.countryDeck, 'KR');
    expect(deck.language, 'Korean');
    expect(deck.explanationRolePlay, 'User explanation');
    expect(deck.rolePlay, 'A Student');
    expect(deck.difficulty, 'beginner');
    expect(deck.colorDeck, 123);

    final deckDb = GeneratedDeckDatabase(
      NativeDatabase.createInBackground(File(deck.dbPath)),
    );
    final cards = await deckDb.generatedDeckDao.getAllCards();
    expect(cards, hasLength(2));
    expect(cards.first.defaultLanguage, 'anjing');
    expect(cards.last.translatedLanguage, 'cat');
    await deckDb.close();
  });

  test('importDeck falls back to file values when form fields are empty', () async {
    await repo.importDeck(
      deckName: 'Animal',
      deckFilePath: euyFile.path,
      deckColor: 123,
      deckLanguage: '',
    );

    final decks = await db.decksDao.getAll();
    expect(decks.first.deckLanguage, 'Korean');
    expect(decks.first.explanationRolePlay, 'From file explanation');
  });

  test('importDeck throws DeckAlreadyExistsException for duplicate deck', () async {
    await repo.importDeck(
      deckName: 'Animal',
      deckFilePath: euyFile.path,
      deckColor: 123,
      deckLanguage: 'ID',
    );

    expect(
      () => repo.importDeck(
        deckName: 'Animal',
        deckFilePath: euyFile.path,
        deckColor: 123,
        deckLanguage: 'ID',
      ),
      throwsA(isA<DeckAlreadyExistsException>()),
    );
  });
}
