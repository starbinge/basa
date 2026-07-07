import 'dart:convert';
import 'dart:io';
import 'package:basa_app_project/features/decks/data/dao/decks_dao.dart';
import 'package:basa_app_project/features/decks/domain/repositories/deck_repository.dart';
import 'package:drift/drift.dart';
import 'package:flutter_archive/flutter_archive.dart';
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
      _dao.updatingActiveHour(
        deckId: deckId,
        additionalHours: additionalHours,
      );

  @override
  Future<void> reConstructData({
    required File mediaFile,
    required File extractedFilePath,
  }) async {
    try {
      final Map<String, dynamic> _jsonData = await readingJsonFile(
        jsonFile: mediaFile,
      );
      final List<Future<void>> existingDefaultFile = [];

      for (var entry in _jsonData.entries) {
        final String codeFile = entry.key;
        final String fileName = entry.value;
        final File _defaultFile = File(
          path.join(extractedFilePath.path, codeFile),
        );
        if (await _defaultFile.exists()) {
          existingDefaultFile.add(
            _defaultFile.rename(path.join(extractedFilePath.path, fileName)),
          );
        }
      }

      if (existingDefaultFile.isNotEmpty) {
        await Future.wait(existingDefaultFile);
      }

      if (await mediaFile.exists()) {
        await mediaFile.delete();
      }
    } on UnimplementedError {
      throw UnimplementedError();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> importDeck({
    required String deckName,
    required String deckFilePath,
    required String deckLanguage,
    required int deckColor,
  }) async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final mediaPath = '${appDocDir.path}/media';
    final deckInByte = File(deckFilePath);

    final mediaDirectory = Directory(mediaPath);
    if (!await mediaDirectory.exists()) {
      await mediaDirectory.create(recursive: true);
    }

    final deckDirectory = Directory(path.join(mediaPath, deckName));
    if (await deckDirectory.exists()) {
      throw DeckAlreadyExistsException();
    }

    await deckDirectory.create(recursive: true);

    await ZipFile.extractToDirectory(
      zipFile: deckInByte,
      destinationDir: deckDirectory,
    );
    final File jsonFile = File(path.join(deckDirectory.path, 'media'));
    await reConstructData(
      mediaFile: jsonFile,
      extractedFilePath: File(deckDirectory.path),
    );

    await _dao.insertNewDeck(
      ImportedDeckCompanion(
        deckName: Value(deckName),
        deckLanguage: Value(deckLanguage),
        apkgPath: Value(deckFilePath),
        extractedPath: Value(deckDirectory.path),
        colorDeck: Value(deckColor),
      ),
    );
  }
}
