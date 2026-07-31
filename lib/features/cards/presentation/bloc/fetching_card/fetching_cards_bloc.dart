import 'dart:io';

import 'package:basa_app_project/core/data/external_database/external_database_accessor.dart';
import 'package:basa_app_project/core/data/initial_database/initial_database.dart';
import 'package:basa_app_project/features/cards/data/dao/cards_dao/cards_dao.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../data/repositories/card_repo_impl.dart';
import '../../../domain/entities/cards_entity.dart';

part 'fetching_cards_event.dart';
part 'fetching_cards_state.dart';

class FetchingCardsBloc extends Bloc<FetchingCardsEvent, FetchingCardsState> {
  final ExternalDatabaseAccessor _databaseAccessor;
  final AppDatabase _appDatabase;

  FetchingCardsBloc({
    required ExternalDatabaseAccessor databaseAccessor,
    required AppDatabase appDatabase,
  }) : _databaseAccessor = databaseAccessor,
       _appDatabase = appDatabase,
       super(FetchingCardInitial()) {
    on<FetchCards>((event, emit) async {
      emit(FetchingCardIsLoading());
      try {
        await _databaseAccessor.closeCurrentDatabase();

        final db = await _databaseAccessor.openExternalDatabase(
          pathFile: event.filePath,
          fileName: event.fileName,
        );

        final decksDao = await _appDatabase.decksDao;
        final repo = CardRepoImpl(decksDao: decksDao, cardsDao: db.cardsDao);

        final cardsEntity = await repo.fetchCards(
          deckId: event.deckId,
          deckName: event.deckName,
          deckCountry: event.deckCountry,
        );

        emit(
          FetchingCardIsFinished(
            cardsEntity: cardsEntity,
            cardsDao: db.cardsDao,
            filePath: event.filePath,
          ),
        );
      } catch (e) {
        emit(FetchingCardIsError(errorMessage: e.toString()));
      }
    });
    on<SearchCard>((event, emit) async {
      final currentState = state;
      if (currentState is! FetchingCardIsFinished) return;

      if (event.searchParams.isEmpty) {
        emit(currentState.copyWith(searchResults: null));
        return;
      }

      await emit.forEach(
        currentState.cardsDao.searchCard(searchParams: event.searchParams),
        onData: (results) => currentState.copyWith(searchResults: results),
      );
    });
  }
}
