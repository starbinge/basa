import 'dart:io';
import 'package:basa_app_project/core/database/initial_database/initial_database.dart';
import 'package:basa_app_project/features/decks/data/dao/decks_dao.dart';
import 'package:drift/drift.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:path/path.dart' as path;

class UnzipTools {
  final DecksDao _query;

  UnzipTools(this._query);

  Future<void> unzipAnkiFile(String filePath, String deckName) async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String mediaPath = '${appDocDir.path}/media';
    final Directory mediaDirectory = Directory(mediaPath);
    final Directory deckDirectory = Directory(path.join(mediaPath, deckName));
    final deckInByte = File(filePath);
    if (await mediaDirectory.exists()) {
      await mediaDirectory.delete(recursive: true);
    }
    await mediaDirectory.create(recursive: true);
    if (await deckDirectory.exists()) {
      await deckDirectory.delete(recursive: true);
    }
    await deckDirectory.create(recursive: true);

    await ZipFile.extractToDirectory(
      zipFile: deckInByte,
      destinationDir: deckDirectory,
    );
    await _query.insertNewDeck(
      ImportedDeckCompanion(
        deckName: Value(deckName),
        deckLanguage: Value("Korean"),
        apkgPath: Value(filePath),
        extractedPath: Value(deckDirectory.path),
      ),
    );
    debugPrint("File imported at ${deckDirectory.path}");
  }
}
