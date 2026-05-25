import 'package:basa_app_project/core/router/app_shell.dart';
import 'package:basa_app_project/features/cards/presentation/pages/main_card_page.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const AppShell()),
    GoRoute(
      path: '/cards/:id',
      builder: (context, state) =>
          MainCardPage(deckId: int.parse(state.pathParameters['id']!)),
    ),
  ],
);
