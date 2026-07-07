import 'dart:io';

import 'package:basa_app_project/features/cards/data/dao/cards_dao.dart';
import 'package:drift/native.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import 'external_database.dart';

class ExternalDatabaseAccessor {
  ExternalDatabase? _database;

  Future<ExternalDatabase> openExternalDatabase({
    required File pathFile,
    required String fileName,
  }) async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
    debugPrint("this is the raw pathFile $pathFile");
    final docDir = await getApplicationDocumentsDirectory();
    final parentFolderName = path.basename(pathFile.parent.path);

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
    debugPrint("this is the local Path: $localPath");
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

  CardsDao? get cardsDao => _database?.cardsDao;

  ExternalDatabase? get externalDatabase => _database;
}
