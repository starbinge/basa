import 'dart:io';
import 'package:path/path.dart' as path;

const String kCollectionAnki21 = 'collection.anki21';
const String kCollectionAnki2 = 'collection.anki2';

/// Resolves which Anki collection database file exists in [extractedPath].
///
/// Prioritizes `collection.anki21` over `collection.anki2`.
/// Returns `null` if neither file exists.
File? resolveAnkiCollectionFile(String extractedPath) {
  final anki21 = File(path.join(extractedPath, kCollectionAnki21));
  if (anki21.existsSync()) return anki21;

  final anki2 = File(path.join(extractedPath, kCollectionAnki2));
  if (anki2.existsSync()) return anki2;

  return null;
}

/// Removes `collection.anki2` if `collection.anki21` exists in [extractedPath].
Future<void> cleanupLegacyCollection(String extractedPath) async {
  final anki21 = File(path.join(extractedPath, kCollectionAnki21));
  final anki2 = File(path.join(extractedPath, kCollectionAnki2));

  if (await anki21.exists() && await anki2.exists()) {
    await anki2.delete();
  }
}
