import 'package:basa_app_project/features/cards/presentation/pages/main_card_page.dart';
import 'package:basa_app_project/features/cards/presentation/widgets/shared/app_bar_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void _noop() {}

void main() {
  Widget buildSliverAppBar(String? flagEmoji) {
    return MaterialApp(
      home: Scaffold(
        body: CustomScrollView(
          slivers: [
            CardAppBar(
              flagEmoji: flagEmoji,
              widget: const MainCardPage(
                deckId: 1,
                deckName: 'MyDeck',
                deckCountry: 'Korean',
                activeHour: '0',
                dbPath: '/tmp/MyDeck.sqlite',
              ),
              flashCardButton: _noop,
              quizButton: _noop,
              historyButton: _noop,
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 400)),
          ],
        ),
      ),
    );
  }

  testWidgets('renders without crashing when flagEmoji is null', (tester) async {
    await tester.pumpWidget(buildSliverAppBar(null));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('MyDeck'), findsOneWidget);
  });

  testWidgets('shows the language fallback icon when flagEmoji is null', (
    tester,
  ) async {
    await tester.pumpWidget(buildSliverAppBar(null));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.language), findsWidgets);
  });

  testWidgets('renders the flag emoji when provided', (tester) async {
    await tester.pumpWidget(buildSliverAppBar('🇰🇷'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('🇰🇷'), findsOneWidget);
  });
}
