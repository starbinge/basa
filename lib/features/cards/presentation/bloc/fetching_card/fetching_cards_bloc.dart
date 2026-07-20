import 'dart:io';

import 'package:basa_app_project/core/data/external_database/external_database_accessor.dart';
import 'package:basa_app_project/core/data/initial_database/initial_database.dart';
import 'package:basa_app_project/features/cards/constants/enums/order_enums.dart';
import 'package:basa_app_project/features/cards/data/models/flashcard_statistic_model.dart';
import 'package:basa_app_project/features/cards/domain/entities/card_history_entity.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';
import 'package:basa_app_project/features/cards/domain/repositories/card_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../data/dao/cards_dao.dart';
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
        final now = DateTime.now();
        final DateTime startOfWeek = now.subtract(
          Duration(days: now.weekday - 1),
        );
        final int _beginWeek = DateTime(
          startOfWeek.year,
          startOfWeek.month,
          startOfWeek.day,
        ).millisecondsSinceEpoch;
        final int _endWeek = _beginWeek + (7 * 24 * 60 * 60 * 1000);
        final int _todayTime = DateTime(
          now.year,
          now.month,
          now.day,
        ).millisecondsSinceEpoch;
        final int _tomorrowTime = DateTime(
          now.year,
          now.month,
          now.day + 1,
        ).millisecondsSinceEpoch;

        final results = await Future.wait([
          db.cardsDao.getThisMonthAccuracy(),
          db.cardsDao.getPreviousMonthAccuracy(),
          db.cardsDao.getWeeklyTimeConsumeList(),
          repo.fetchCards(
            deckId: event.deckId,
            deckName: event.deckName,
            deckCountry: event.deckCountry,
          ),

          // History
          db.cardsDao.getTimeConsumeTopCards(
            begin: _todayTime,
            end: _tomorrowTime,
            orderBy: OrderEnums.desc,
            limit: 50,
          ),
          db.cardsDao.getTimeConsumeTopCards(
            begin: _beginWeek,
            end: _endWeek,
            orderBy: OrderEnums.asc,
            limit: 50,
          ),
        ]);

        final CardsEntity cardsEntity = results[3] as CardsEntity;
        final DeckAccuracy thisMonthAccuracy = results[0] as DeckAccuracy;
        final DeckAccuracy previousMonthAccuracy = results[1] as DeckAccuracy;
        final List<DeckTimeConsume> weeklyTimeConsumeData =
            results[2] as List<DeckTimeConsume>;

        final List<CardsDetailEntity> _todayHistory =
            results[4] as List<CardsDetailEntity>;

        final List<CardsDetailEntity> _weeklyHistory =
            results[5] as List<CardsDetailEntity>;
        emit(
          FetchingCardIsFinished(
            cardsEntity: cardsEntity,
            cardsDao: db.cardsDao,
            filePath: event.filePath,
            weeklyTimeConsumeData: weeklyTimeConsumeData,
            thisMonthAccuracyNumber: thisMonthAccuracy,
            previousMonthAccuracyNumber: previousMonthAccuracy,
            cardHistoryEntity: CardHistoryEntity(
              weeklyHistory: _weeklyHistory,
              todayHistory: _todayHistory,
            ),
          ),
        );
      } catch (e) {
        emit(FetchingCardIsError(errorMessage: e.toString()));
      }
    });
  }
}
