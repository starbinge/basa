import 'package:basa_app_project/core/data/external_database/external_database.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';

Future<ExternalDatabase> createTestDatabase() async {
  return ExternalDatabase(NativeDatabase.memory());
}

NotesTableCompanion buildNoteCompanion({
  required int id,
  required String flds,
  String tags = '',
  int mid = 0,
}) {
  return NotesTableCompanion(
    id: Value(id),
    flds: Value(flds),
    mid: Value(mid),
    tags: Value(tags),
  );
}

CardsTableCompanion buildCardCompanion({
  required int id,
  required int nid,
  int queue = 0,
  int reps = 0,
  int factor = 250,
  int ivl = 0,
  int odue = 0,
  int left = 10,
  int flags = 0,
}) {
  return CardsTableCompanion(
    id: Value(id),
    nid: Value(nid),
    queue: Value(queue),
    reps: Value(reps),
    factor: Value(factor),
    ivl: Value(ivl),
    odue: Value(odue),
    left: Value(left),
    flags: Value(flags),
  );
}

RevlogTableCompanion buildRevlogCompanion({
  required int id,
  required int cid,
  int ease = 3,
  int factor = 250,
  int time = 1000,
  int usn = -1,
  int ivl = 0,
  int lastIvl = 0,
  int type = 0,
}) {
  return RevlogTableCompanion(
    id: Value(id),
    cid: Value(cid),
    usn: Value(usn),
    ease: Value(ease),
    ivl: Value(ivl),
    lastIvl: Value(lastIvl),
    factor: Value(factor),
    time: Value(time),
    type: Value(type),
  );
}

Future<void> insertNoteAndCard(
  ExternalDatabase db, {
  required int cardId,
  required int noteId,
  required String flds,
  int queue = 0,
  int reps = 0,
  int factor = 250,
  int left = 10,
}) async {
  await db.into(db.notesTable).insert(
        buildNoteCompanion(id: noteId, flds: flds),
      );
  await db.into(db.cardsTable).insert(
        buildCardCompanion(
          id: cardId,
          nid: noteId,
          queue: queue,
          reps: reps,
          factor: factor,
          left: left,
        ),
      );
}
