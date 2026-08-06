import 'package:basa_app_project/core/data/initial_database/initial_database.dart';
import 'package:basa_app_project/core/errors/input_errors.dart';
import 'package:basa_app_project/core/utils/file_picker.dart';
import 'package:basa_app_project/features/decks/data/repositories/deck_repository_impl.dart';
import 'package:basa_app_project/features/decks/presentation/bloc/deck_import/deck_import_bloc.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeFilePickerService extends FilePickerService {
  _FakeFilePickerService(this.path);

  final String path;

  @override
  Future<String> getFilePath() async => path;
}

void main() {
  late DeckImportBloc importBloc;

  DeckImportBloc buildBloc(String path) {
    return DeckImportBloc(
      repository: DeckRepositoryImpl(decksDao: AppDatabase(NativeDatabase.memory()).decksDao),
      filePicker: _FakeFilePickerService(path),
    );
  }

  setUp(() {
    importBloc = buildBloc('');
  });

  tearDown(() async {
    await importBloc.close();
  });

  group('DeckImportBloc.pickFile', () {
    test('returns an empty string when the picker is cancelled', () async {
      final bloc = buildBloc('');
      final path = await bloc.pickFile();
      expect(path, '');
      await bloc.close();
    });

    test('returns the path for a .euy file', () async {
      final bloc = buildBloc('/downloads/sample.euy');
      final path = await bloc.pickFile();
      expect(path, '/downloads/sample.euy');
      await bloc.close();
    });

    test('returns the path for an uppercase .EUY file', () async {
      final bloc = buildBloc('/downloads/sample.EUY');
      final path = await bloc.pickFile();
      expect(path, '/downloads/sample.EUY');
      await bloc.close();
    });

    test('throws NotEuyFileException for a non-.euy file', () async {
      final bloc = buildBloc('/downloads/sample.txt');
      expect(bloc.pickFile(), throwsA(isA<NotEuyFileException>()));
      await bloc.close();
    });
  });
}
