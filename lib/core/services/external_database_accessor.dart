import 'dart:io';

import 'package:basa_app_project/core/database/external_database/external_database.dart';
import 'package:basa_app_project/features/cards/data/dao/cards_dao.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ExternalDatabaseAccessor {
  ExternalDatabase? _database;

  Future<ExternalDatabase> fetchAnkiDatabase({
    required File pathFile,
    required String fileName,
  }) async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
    final docDir = await getApplicationDocumentsDirectory();
    final localPath = path.join(docDir.path, fileName);
    final isFileExist = await File(localPath).exists();
    if (!isFileExist) {
      await pathFile.copy(localPath);
    }
    final executor = NativeDatabase.createInBackground(File(localPath));
    _database = ExternalDatabase(executor);
    return _database!;
  }

  CardsDao? get cardsDao => _database?.cardsDao;
  ExternalDatabase? get externalDatabase => _database;
}
