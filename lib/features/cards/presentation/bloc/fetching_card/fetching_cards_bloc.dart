import 'dart:io';

import 'package:basa_app_project/core/data/generated_database/generated_database.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';
import 'package:bloc/bloc.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/cards_entity.dart';

part 'fetching_cards_event.dart';
part 'fetching_cards_state.dart';

class FetchingCardsBloc extends Bloc<FetchingCardsEvent, FetchingCardsState> {
  GeneratedDeckDatabase? _generatedDatabase;

  FetchingCardsBloc() : super(FetchingCardInitial()) {
    on<FetchCards>((event, emit) async {
      emit(FetchingCardIsLoading());
      try {
        await _generatedDatabase?.close();

        final db = GeneratedDeckDatabase(
          NativeDatabase.createInBackground(File(event.dbPath)),
        );
        _generatedDatabase = db;

        final listCard = await db.generatedDeckDao.getAllCards();

        emit(
          FetchingCardIsFinished(
            cardsEntity: CardsEntity(
              deckName: event.deckName,
              deckCountry: event.deckCountry,
              listCard: listCard,
            ),
            generatedDeckDao: db.generatedDeckDao,
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
        emit(
          FetchingCardIsFinished(
            cardsEntity: currentState.cardsEntity,
            generatedDeckDao: currentState.generatedDeckDao,
          ),
        );
        return;
      }

      await emit.forEach(
        currentState.generatedDeckDao.searchCard(
          searchParams: event.searchParams,
        ),
        onData: (results) => currentState.copyWith(searchResults: results),
      );
    });
  }

  @override
  Future<void> close() async {
    await _generatedDatabase?.close();
    _generatedDatabase = null;
    await super.close();
  }
}
