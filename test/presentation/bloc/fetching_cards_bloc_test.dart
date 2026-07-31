import 'dart:io';

import 'package:basa_app_project/core/data/external_database/external_database.dart';
import 'package:basa_app_project/core/data/external_database/external_database_accessor.dart';
import 'package:basa_app_project/core/data/initial_database/initial_database.dart';
import 'package:basa_app_project/features/cards/data/dao/cards_dao/cards_dao.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_entity.dart';
import 'package:basa_app_project/features/cards/presentation/bloc/fetching_card/fetching_cards_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../data/dao/db_test_helper.dart';

class MockExternalDatabaseAccessor extends Mock
    implements ExternalDatabaseAccessor {}

class MockCardsDao extends Mock implements CardsDao {}

CardsDetailEntity buildCard({
  required int id,
  int queue = 100,
  String? def,
  String? trans,
}) {
  return CardsDetailEntity(
    id: id,
    noteId: id,
    queue: queue,
    reps: 0,
    odue: 0,
    ivl: 0,
    left: 10,
    defaultLanguage: def ?? 'word$id',
    translatedLanguage: trans ?? 'translation$id',
    descriptions: const [],
    audioPath: const [],
    factor: 250,
    flags: 0,
  );
}

void main() {
  late MockExternalDatabaseAccessor accessor;
  late AppDatabase appDatabase;
  late ExternalDatabase searchDb;
  late File deckFile;

  setUp(() async {
    registerFallbackValue(File(''));
    accessor = MockExternalDatabaseAccessor();
    appDatabase = AppDatabase(NativeDatabase.memory());
    searchDb = ExternalDatabase(NativeDatabase.memory());
    await insertNoteAndCard(searchDb, cardId: 1, noteId: 1, flds: 'dog\u001fanjing');
    when(() => accessor.closeCurrentDatabase()).thenAnswer((_) async {});

    final dir = Directory.systemTemp.createTempSync('deck_test');
    deckFile = File('${dir.path}/deck.apkg')..writeAsStringSync('dummy');
  });

  tearDown(() async {
    await appDatabase.close();
    await searchDb.close();
  });

  void stubOpenDatabase() {
    when(
      () => accessor.openExternalDatabase(
        pathFile: any(named: 'pathFile'),
        fileName: any(named: 'fileName'),
      ),
    ).thenAnswer((_) async => searchDb);
  }

  FetchCards fetchEvent() {
    return FetchCards(
      deckId: 1,
      deckName: 'Animal',
      deckCountry: 'ID',
      filePath: deckFile,
      fileName: 'deck.apkg',
    );
  }

  FetchingCardIsFinished finishedSeed({
    required CardsDao cardsDao,
    List<CardsDetailEntity>? searchResults,
  }) {
    return FetchingCardIsFinished(
      cardsEntity: CardsEntity(
        deckName: 'Animal',
        deckCountry: 'ID',
        listCard: [buildCard(id: 1, def: 'dog', trans: 'anjing')],
      ),
      cardsDao: cardsDao,
      filePath: deckFile,
      searchResults: searchResults,
    );
  }

  group('FetchingCardsBloc', () {
    blocTest<FetchingCardsBloc, FetchingCardsState>(
      'fetches cards and emits a finished state',
      build: () {
        stubOpenDatabase();
        return FetchingCardsBloc(
          databaseAccessor: accessor,
          appDatabase: appDatabase,
        );
      },
      act: (bloc) => bloc.add(fetchEvent()),
      expect: () => [
        isA<FetchingCardIsLoading>(),
        isA<FetchingCardIsFinished>()
            .having((s) => s.cardsEntity.deckName, 'deckName', 'Animal')
            .having((s) => s.cardsEntity.listCard.length, 'card count', 1),
      ],
    );

    blocTest<FetchingCardsBloc, FetchingCardsState>(
      'emits an error state when opening the database fails',
      build: () {
        when(
          () => accessor.openExternalDatabase(
            pathFile: any(named: 'pathFile'),
            fileName: any(named: 'fileName'),
          ),
        ).thenThrow(Exception('db error'));
        return FetchingCardsBloc(
          databaseAccessor: accessor,
          appDatabase: appDatabase,
        );
      },
      act: (bloc) => bloc.add(fetchEvent()),
      expect: () => [
        isA<FetchingCardIsLoading>(),
        isA<FetchingCardIsError>().having(
          (s) => s.errorMessage,
          'errorMessage',
          'Exception: db error',
        ),
      ],
    );

    blocTest<FetchingCardsBloc, FetchingCardsState>(
      'clears search results when the search params are empty',
      build: () => FetchingCardsBloc(
        databaseAccessor: accessor,
        appDatabase: appDatabase,
      ),
      seed: () => finishedSeed(
        cardsDao: searchDb.cardsDao,
        searchResults: [buildCard(id: 1, def: 'dog', trans: 'anjing')],
      ),
      act: (bloc) => bloc.add(SearchCard(searchParams: '')),
      expect: () => [
        isA<FetchingCardIsFinished>().having(
          (s) => s.searchResults,
          'searchResults',
          isNull,
        ),
      ],
    );

    blocTest<FetchingCardsBloc, FetchingCardsState>(
      'emits matching cards when searching',
      build: () => FetchingCardsBloc(
        databaseAccessor: accessor,
        appDatabase: appDatabase,
      ),
      seed: () {
        final mockCardsDao = MockCardsDao();
        when(
          () => mockCardsDao.searchCard(searchParams: 'dog'),
        ).thenAnswer(
          (_) => Stream.value([buildCard(id: 1, def: 'dog', trans: 'anjing')]),
        );
        return finishedSeed(
          cardsDao: mockCardsDao,
        );
      },
      act: (bloc) => bloc.add(SearchCard(searchParams: 'dog')),
      expect: () => [
        isA<FetchingCardIsFinished>().having(
          (s) => s.searchResults,
          'searchResults',
          isA<List<CardsDetailEntity>>().having((list) => list.length, 'length', 1),
        ),
      ],
    );
  });
}
