import 'dart:io';

import 'package:basa_app_project/core/database/external_database/external_database.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';

class ExternalDatabaseAccessor {
  static final Map<String, ExternalDatabase> _cache = {};

  static ExternalDatabase openConnectionFromFile({required String dbPath}) {
    return _cache.putIfAbsent(dbPath, () {
      return ExternalDatabase(
        LazyDatabase(() async {
          final file = File(dbPath);
          if (!await file.exists()) {
            throw Exception("File tidak ditemukan di sistem HP!");
          }
          return NativeDatabase.createInBackground(file);
        }),
      );
    });
  }

  /// Call this when you're done with a database file (e.g. user removes it)
  static Future<void> closeConnection({required String dbPath}) async {
    final db = _cache.remove(dbPath);
    await db?.close();
  }

  /// Call this on app shutdown
  static Future<void> closeAll() async {
    for (final db in _cache.values) {
      await db.close();
    }
    _cache.clear();
  }
}
