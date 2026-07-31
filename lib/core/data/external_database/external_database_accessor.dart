import 'dart:io';

import 'package:basa_app_project/features/cards/data/dao/cards_dao/cards_dao.dart';
import 'package:basa_app_project/features/cards/data/dao/history_dao/history_dao.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'external_database.dart';

class ExternalDatabaseAccessor {
  ExternalDatabase? _database;
  String? _parentFolderName;

  Future<ExternalDatabase> openExternalDatabase({
    required File pathFile,
    required String fileName,
  }) async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
    final docDir = await getApplicationDocumentsDirectory();
    _parentFolderName = pathFile.parent.path;
    final String parentFolderName = path.basename(pathFile.parent.path);

    final targetDirectoryPath = path.join(
      docDir.path,
      'media',
      parentFolderName,
    );
    final localPath = path.join(targetDirectoryPath, fileName);

    final targetDir = Directory(targetDirectoryPath);
    if (!await targetDir.exists()) {
      await targetDir.create(recursive: true);
    }

    final isFileExist = await File(localPath).exists();

    if (!isFileExist) {
      await pathFile.copy(localPath);
    }
    final executor = NativeDatabase.createInBackground(File(localPath));
    _database = ExternalDatabase(executor);
    return _database!;
  }

  Future<void> closeCurrentDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  String? get filePath => _parentFolderName;

  CardsDao? get cardsDao => _database?.cardsDao;

  HistoryDao? get historyDao => _database?.historyDao;

  ExternalDatabase? get externalDatabase => _database;
}
