import 'dart:io';

import 'package:basa_app_project/core/data/generated_database/generated_database.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_entity.dart';
import 'package:basa_app_project/features/cards/presentation/bloc/fetching_card/fetching_cards_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

CardsDetailEntity buildCard({
  required int id,
  String? def,
  String? trans,
}) {
  return CardsDetailEntity(
    id: id,
    defaultLanguage: def ?? 'word$id',
    translatedLanguage: trans ?? 'translation$id',
    additionalContext: '',
    pronunciation: '',
  );
}

void main() {
  GeneratedDeckDatabase? searchDb;
  late String dbPath;
  late String invalidDbPath;

  setUp(() async {
    final dir = Directory.systemTemp.createTempSync('fetching_cards_test');
    dbPath = '${dir.path}/animal.sqlite';
    final seedDb = GeneratedDeckDatabase(
      NativeDatabase.createInBackground(File(dbPath)),
    );
    await seedDb.generatedDeckDao.insertCard(
      GeneratedCardsTableCompanion.insert(
        defaultLanguage: 'dog',
        translation: 'anjing',
        additionalContext: '',
        pronunciation: '',
      ),
    );
    await seedDb.close();

    invalidDbPath = '${dir.path}/not_a_database';
    Directory(invalidDbPath).createSync();
  });

  tearDown(() async {
    await searchDb?.close();
  });

  GeneratedDeckDatabase openSearchDb() {
    searchDb = GeneratedDeckDatabase(
      NativeDatabase.createInBackground(File(dbPath)),
    );
    return searchDb!;
  }

  FetchCards fetchEvent() {
    return FetchCards(
      deckId: 1,
      deckName: 'Animal',
      deckCountry: 'ID',
      dbPath: dbPath,
    );
  }

  FetchingCardIsFinished finishedSeed({
    required GeneratedDeckDao generatedDeckDao,
    List<CardsDetailEntity>? searchResults,
  }) {
    return FetchingCardIsFinished(
      cardsEntity: CardsEntity(
        deckName: 'Animal',
        deckCountry: 'ID',
        listCard: [buildCard(id: 1, def: 'dog', trans: 'anjing')],
      ),
      generatedDeckDao: generatedDeckDao,
      searchResults: searchResults,
    );
  }

  group('FetchingCardsBloc', () {
    blocTest<FetchingCardsBloc, FetchingCardsState>(
      'fetches cards and emits a finished state',
      build: () => FetchingCardsBloc(),
      act: (bloc) => bloc.add(fetchEvent()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        isA<FetchingCardIsLoading>(),
        isA<FetchingCardIsFinished>()
            .having((s) => s.cardsEntity.deckName, 'deckName', 'Animal')
            .having((s) => s.cardsEntity.listCard.length, 'card count', 1),
      ],
    );

    blocTest<FetchingCardsBloc, FetchingCardsState>(
      'emits an error state when opening the database fails',
      build: () => FetchingCardsBloc(),
      act: (bloc) => bloc.add(
        FetchCards(
          deckId: 1,
          deckName: 'Animal',
          deckCountry: 'ID',
          dbPath: invalidDbPath,
        ),
      ),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        isA<FetchingCardIsLoading>(),
        isA<FetchingCardIsError>(),
      ],
    );

    blocTest<FetchingCardsBloc, FetchingCardsState>(
      'clears search results when the search params are empty',
      build: () => FetchingCardsBloc(),
      seed: () => finishedSeed(
        generatedDeckDao: openSearchDb().generatedDeckDao,
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
      build: () => FetchingCardsBloc(),
      seed: () => finishedSeed(generatedDeckDao: openSearchDb().generatedDeckDao),
      act: (bloc) => bloc.add(SearchCard(searchParams: 'dog')),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        isA<FetchingCardIsFinished>().having(
          (s) => s.searchResults,
          'searchResults',
          isA<List<CardsDetailEntity>>().having((list) => list.length, 'length', 1),
        ),
      ],
    );

    test('closing the bloc also closes the opened deck database', () async {
      final bloc = FetchingCardsBloc();
      addTearDown(bloc.close);

      final finished = bloc.stream.firstWhere(
        (state) => state is FetchingCardIsFinished,
      );
      bloc.add(fetchEvent());
      final finishedState = await finished;
      final dao = (finishedState as FetchingCardIsFinished).generatedDeckDao;

      await bloc.close();

      await expectLater(dao.getAllCards(), throwsA(anything));
    });
  });
}
