import 'package:basa_app_project/core/widgets/timer_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('renders the formatted initial time', (tester) async {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) =>
              const Scaffold(body: TimerContainer(time: 2, totalAnswered: 0)),
        ),
        GoRoute(
          path: '/stats-quiz-game',
          builder: (_, __) => const Scaffold(body: Text('stats page')),
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));

    expect(find.text('0 : 2'), findsOneWidget);
  });

  testWidgets('decrements every second and navigates when time runs out',
      (tester) async {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) =>
              const Scaffold(body: TimerContainer(time: 2, totalAnswered: 0)),
        ),
        GoRoute(
          path: '/stats-quiz-game',
          builder: (_, __) => const Scaffold(body: Text('stats page')),
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));

    await tester.pump(const Duration(seconds: 1));
    expect(find.text('0 : 1'), findsOneWidget);

    await tester.pump(const Duration(seconds: 1));
    expect(find.text('0 : 0'), findsOneWidget);

    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.text('stats page'), findsOneWidget);
  });
}
