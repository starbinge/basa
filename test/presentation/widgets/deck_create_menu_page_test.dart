import 'dart:convert';
import 'dart:io';

import 'package:basa_app_project/core/data/initial_database/initial_database.dart';
import 'package:basa_app_project/core/utils/file_picker.dart';
import 'package:basa_app_project/features/decks/data/repositories/deck_repository_impl.dart';
import 'package:basa_app_project/features/decks/presentation/bloc/deck_import/deck_import_bloc.dart';
import 'package:basa_app_project/features/decks/presentation/widgets/deck_input_page_widgets/deck_create_menu_page.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

class _FakePathProviderPlatform extends PathProviderPlatform {
  _FakePathProviderPlatform(this.documentsPath);

  final String documentsPath;

  @override
  Future<String?> getApplicationDocumentsPath() async => documentsPath;
}

class _FakeFilePickerService extends FilePickerService {
  _FakeFilePickerService(this.path);

  final String path;

  @override
  Future<String> getFilePath() async => path;
}

void main() {
  late Directory tempDir;
  late File euyFile;
  late AppDatabase db;
  late DeckImportBloc importBloc;
  late bool generateTapped;

  setUp(() async {
    tempDir = Directory.systemTemp.createTempSync('create_menu_test');
    PathProviderPlatform.instance = _FakePathProviderPlatform(tempDir.path);

    euyFile = File(path.join(tempDir.path, 'sample.euy'));
    await euyFile.writeAsString(
      jsonEncode({
        'language': 'Korean',
        'countryDeck': 'KR',
        'rolePlay': 'A Student',
        'explanationRolePlay': 'From file explanation',
        'difficulty': 'beginner',
        'listCards': [
          {
            'defaultLanguage': 'anjing',
            'translation': 'dog',
            'additionalContext': '',
            'pronunciation': '',
          },
        ],
      }),
    );

    db = AppDatabase(NativeDatabase.memory());
    importBloc = DeckImportBloc(
      repository: DeckRepositoryImpl(decksDao: db.decksDao),
      filePicker: _FakeFilePickerService(euyFile.path),
    );
    generateTapped = false;
  });

  tearDown(() async {
    await importBloc.close();
    await db.close();
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  Future<void> pumpMenu(WidgetTester tester) async {
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [BlocProvider.value(value: importBloc)],
        child: MaterialApp(
          home: Scaffold(
            body: DeckCreateMenuPage(
              theme: ThemeData(brightness: Brightness.light),
              onGenerateTap: () => generateTapped = true,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('renders both menu options', (tester) async {
    await pumpMenu(tester);

    expect(find.text('Import Deck (.euy)'), findsOneWidget);
    expect(find.text('Create New Deck'), findsOneWidget);
  });

  testWidgets('tapping Create New Deck invokes onGenerateTap', (tester) async {
    await pumpMenu(tester);

    await tester.tap(find.text('Create New Deck'));
    await tester.pumpAndSettle();

    expect(generateTapped, isTrue);
  });

  testWidgets('importing a .euy file asks for a deck name and imports it', (
    tester,
  ) async {
    await pumpMenu(tester);

    await tester.tap(find.text('Import Deck (.euy)'));
    await tester.pumpAndSettle();

    expect(find.text('Deck name'), findsOneWidget);

    final importDone = importBloc.stream
        .firstWhere((s) => s.isFinished && !s.isError)
        .timeout(const Duration(seconds: 5));

    await tester.enterText(find.byType(TextField).last, 'MyDeck');
    await tester.tap(find.text('Import'));
    await tester.pumpAndSettle();

    await tester.runAsync(() => importDone);
    await tester.pumpAndSettle();

    final decks = await db.decksDao.getAll();
    expect(decks, hasLength(1));
    expect(decks.first.deckName, 'MyDeck');
  });

  testWidgets('cancelling the name dialog does not import', (tester) async {
    await pumpMenu(tester);

    await tester.tap(find.text('Import Deck (.euy)'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    final decks = await db.decksDao.getAll();
    expect(decks, isEmpty);
  });

  testWidgets(
    'importing a non-.euy file shows a snackbar and does not import',
    (tester) async {
      final rejectingBloc = DeckImportBloc(
        repository: DeckRepositoryImpl(decksDao: db.decksDao),
        filePicker: _FakeFilePickerService(
          path.join(tempDir.path, 'sample.txt'),
        ),
      );
      addTearDown(rejectingBloc.close);

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [BlocProvider.value(value: rejectingBloc)],
          child: MaterialApp(
            home: Scaffold(
              body: DeckCreateMenuPage(
                theme: ThemeData(brightness: Brightness.light),
                onGenerateTap: () => generateTapped = true,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Import Deck (.euy)'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Only .euy files are supported'), findsOneWidget);
      expect(find.text('Deck name'), findsNothing);

      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();

      final decks = await db.decksDao.getAll();
      expect(decks, isEmpty);
    },
  );
}
