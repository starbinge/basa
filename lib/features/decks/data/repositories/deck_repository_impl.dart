import 'dart:convert';
import 'dart:io';

import 'package:basa_app_project/core/data/generated_database/generated_database.dart';
import 'package:basa_app_project/features/decks/data/dao/decks_dao.dart';
import 'package:basa_app_project/features/decks/domain/repositories/deck_repository.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../../../../core/data/initial_database/initial_database.dart';
import '../../../../core/errors/input_errors.dart';
import '../../../../core/utils/reading_json_file.dart';

class DeckRepositoryImpl implements DeckRepository {
  final DecksDao _dao;

  DeckRepositoryImpl({required DecksDao decksDao}) : _dao = decksDao;

  @override
  Future<List<ImportedDeckData>> getAll() => _dao.getAll();

  @override
  Future<bool> isDeckExists(String deckName) async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final deckDirectory = Directory(
      path.join(appDocDir.path, 'media', deckName),
    );
    return deckDirectory.exists();
  }

  @override
  Future<int> updatingActiveHour({
    required int deckId,
    required int additionalHours,
  }) =>
      _dao.updatingActiveHour(deckId: deckId, additionalHours: additionalHours);

  Future<void> _buildDeckDatabase({
    required String dbPath,
    required List<dynamic> listCards,
  }) async {
    final database = GeneratedDeckDatabase(
      NativeDatabase.createInBackground(File(dbPath)),
    );

    for (final dynamic rawCard in listCards) {
      final Map<String, dynamic> card = rawCard as Map<String, dynamic>;
      await database.generatedDeckDao.insertCard(
        GeneratedCardsTableCompanion.insert(
          defaultLanguage: card['defaultLanguage'] ?? '',
          translation: card['translation'] ?? '',
          additionalContext: card['additionalContext'] ?? '',
          pronunciation: card['pronunciation'] ?? '',
        ),
      );
    }

    await database.close();
  }

  @override
  Future<void> importDeck({
    required String deckName,
    required String deckFilePath,
    required int deckColor,
    required String deckLanguage,
    String explanationRolePlay = '',
  }) async {
    // Kita ambil dulu direktori dokumen aplikasi
    final appDocDir = await getApplicationDocumentsDirectory();

    //Inisiasi variabel dengan nama direktori dotEuy (untuk menyimpan .euy)
    final mediaPath = '${appDocDir.path}/dotEuy';

    //Inisiasi variabel dengan nama direktori koleksi (untuk menyimpan .sqlite)
    final deckCollectionPath = '${appDocDir.path}/collections';
    //Inisiasi original file euy
    final originalFile = File(deckFilePath);
    //Kita baca file json yang datang dari deckFilePath
    final parsedJson = await readingJsonFile(jsonFile: originalFile);

    //check dulu ada nggak direktori dotEuy
    final mediaDirectory = Directory(mediaPath);
    if (!await mediaDirectory.exists()) {
      await mediaDirectory.create(recursive: true);
    }

    //lanjut check ada nggak direktori collection
    final deckCollectionDir = Directory(deckCollectionPath);
    if (!await deckCollectionDir.exists()) {
      await deckCollectionDir.create(recursive: true);
    }

    // nge check, deck udah ada atau belum
    final euyFile = File(path.join(mediaPath, '$deckName.euy'));
    if (await euyFile.exists()) {
      throw DeckAlreadyExistsException();
    }
    await originalFile.copy(euyFile.path);

    // Inisiasi data dari Json
    final String rolePlay = parsedJson['rolePlay'] as String? ?? '';
    final String difficulty = parsedJson['difficulty'] as String? ?? '';

    // Proses looping untuk memasukkan listCards ke dalam database baru.

    //inisiasi path database
    final dbPath = path.join(deckCollectionPath, '$deckName.sqlite');

    //Bikin database baru dan isi dengan kartu-kartu dari file .euy
    final listCards = parsedJson['listCards'] as List<dynamic>? ?? [];
    await _buildDeckDatabase(dbPath: dbPath, listCards: listCards);

    //Memasukkan metadata ke dalam main database
    await _dao.insertNewDeck(
      ImportedDeckCompanion(
        dbPath: Value(dbPath),
        deckName: Value(deckName),
        deckLanguage: Value(
          deckLanguage.isEmpty
              ? (parsedJson['language'] as String? ?? '')
              : deckLanguage,
        ),
        countryDeck: Value(parsedJson['countryDeck'] as String? ?? ''),
        filePath: Value(deckFilePath),
        colorDeck: Value(deckColor),
        language: Value(parsedJson['language'] as String? ?? ''),
        rolePlay: Value(rolePlay),
        explanationRolePlay: Value(
          explanationRolePlay.isEmpty
              ? (parsedJson['explanationRolePlay'] as String? ?? '')
              : explanationRolePlay,
        ),
        difficulty: Value(difficulty),
      ),
    );
  }

  @override
  Future<void> generateDeck({
    required Map<String, dynamic> jsonData,
    required String deckName,
    required int colorDeck,
    required String countryDeck,
  }) async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final dotEuyPath = path.join(appDocDir.path, 'dotEuy');
    final collectionsPath = path.join(appDocDir.path, 'collections');

    final dotEuyDir = Directory(dotEuyPath);
    if (!await dotEuyDir.exists()) {
      await dotEuyDir.create(recursive: true);
    }

    final euyFile = File(path.join(dotEuyPath, '$deckName.euy'));
    if (await euyFile.exists()) {
      throw DeckAlreadyExistsException();
    }
    await euyFile.writeAsString(jsonEncode(jsonData));

    final jsonParsed = await readingJsonFile(jsonFile: euyFile);

    final collectionsDir = Directory(collectionsPath);
    if (!await collectionsDir.exists()) {
      await collectionsDir.create(recursive: true);
    }

    final dbPath = path.join(collectionsPath, '$deckName.sqlite');
    final listCards = jsonParsed['listCards'] as List<dynamic>? ?? [];
    await _buildDeckDatabase(dbPath: dbPath, listCards: listCards);

    await _dao.insertNewDeck(
      ImportedDeckCompanion(
        deckName: Value(deckName),
        deckLanguage: Value(countryDeck),
        countryDeck: Value(countryDeck),
        dbPath: Value(dbPath),
        filePath: Value(euyFile.path),
        colorDeck: Value(colorDeck),
        language: Value(jsonParsed['language'] ?? ''),
        rolePlay: Value(jsonParsed['rolePlay'] ?? ''),
        difficulty: Value(jsonParsed['difficulty'] ?? ''),
        explanationRolePlay: Value(jsonParsed['explanationRolePlay'] ?? ''),
      ),
    );
  }
}
