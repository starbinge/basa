import 'dart:io';

import 'package:basa_app_project/core/router/app_shell.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';
import 'package:basa_app_project/features/cards/presentation/bloc/fetching_card/fetching_cards_bloc.dart';
import 'package:basa_app_project/features/cards/presentation/bloc/flash_card/flash_card_bloc.dart';
import 'package:basa_app_project/features/cards/presentation/pages/flash_card_page.dart';
import 'package:basa_app_project/features/cards/presentation/pages/main_card_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/cards/data/models/fetching_cards_model.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const AppShell()),
    GoRoute(
      path: '/cards/:id/:fileName/:deckName/:deckCountry',
      builder: (context, state) => MainCardPage(
        deckId: int.parse(state.pathParameters['id']!),
        fileName: state.pathParameters['fileName']!,
        filePath: state.extra as File,
        deckName: state.pathParameters['deckName']!,
        deckCountry: state.pathParameters['deckCountry']!,
      ),
      routes: [
        GoRoute(
          path: 'flashcard',
          pageBuilder: (context, state) {
            final fetchingCardsBloc = state.extra as FetchingCardsBloc;

            List<CardsDetailEntity> rawCards = [];
            if (fetchingCardsBloc.state is FetchingCardIsFinished) {
              rawCards = (fetchingCardsBloc.state as FetchingCardIsFinished)
                  .cardsEntity
                  .listCard;
            }

            return MaterialPage(
              child: BlocProvider.value(
                value: FlashCardBloc()
                  ..add(GenerateFlashCard(listCard: rawCards)),
                child: const FleshCardPage(),
              ),
            );
          },
        ),
      ],
    ),
  ],
);
