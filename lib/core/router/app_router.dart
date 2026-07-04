import 'dart:io';

import 'package:basa_app_project/core/router/app_shell.dart';
import 'package:basa_app_project/features/cards/presentation/bloc/fetching_card/fetching_cards_bloc.dart';
import 'package:basa_app_project/features/cards/presentation/pages/flesh_card_page.dart';
import 'package:basa_app_project/features/cards/presentation/pages/main_card_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
          builder: (context, state) {
            final activeBloc = BlocProvider.of<FetchingCardsBloc>(context);
            return BlocProvider.value(
              value: activeBloc,
              child: FleshCardPage(),
            );
          },
        ),
      ],
    ),
  ],
);
