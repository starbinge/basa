import 'package:basa_app_project/features/decks/presentation/widgets/deck_input_page_widgets/role_play_input_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ThemeData theme;
  late TextEditingController controller;

  setUp(() {
    theme = ThemeData(brightness: Brightness.light);
    controller = TextEditingController();
  });

  tearDown(() {
    controller.dispose();
  });

  Future<void> pumpRolePlayPage(
    WidgetTester tester, {
    required PageController pageController,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PageView(
            controller: pageController,
            children: [
              const ColoredBox(color: Colors.red),
              RolePlayInputPage(
                theme: theme,
                rolePlayController: controller,
                pageController: pageController,
              ),
              const ColoredBox(color: Colors.green),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('renders title, hint, and navigation buttons', (tester) async {
    final pageController = PageController(initialPage: 1);
    addTearDown(pageController.dispose);

    await pumpRolePlayPage(tester, pageController: pageController);

    expect(find.text('Describe your role play'), findsOneWidget);
    expect(find.text('Back'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
  });

  testWidgets('Next button is disabled until text is entered', (tester) async {
    final pageController = PageController(initialPage: 1);
    addTearDown(pageController.dispose);

    await pumpRolePlayPage(tester, pageController: pageController);

    final nextButton = tester.widget<TextButton>(
      find.ancestor(of: find.text('Next'), matching: find.byType(TextButton)),
    );
    expect(nextButton.onPressed, isNull);

    await tester.enterText(find.byType(TextField), 'A bartender in Seoul');
    await tester.pumpAndSettle();

    final enabledNextButton = tester.widget<TextButton>(
      find.ancestor(of: find.text('Next'), matching: find.byType(TextButton)),
    );
    expect(enabledNextButton.onPressed, isNotNull);
    expect(controller.text, 'A bartender in Seoul');
  });

  testWidgets('Next navigates to the following page when enabled', (
    tester,
  ) async {
    final pageController = PageController(initialPage: 1);
    addTearDown(pageController.dispose);

    await pumpRolePlayPage(tester, pageController: pageController);
    await tester.enterText(find.byType(TextField), 'A bartender in Seoul');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(pageController.page, 2.0);
  });

  testWidgets('Back navigates to the previous page', (tester) async {
    final pageController = PageController(initialPage: 1);
    addTearDown(pageController.dispose);

    await pumpRolePlayPage(tester, pageController: pageController);
    await tester.tap(find.text('Back'));
    await tester.pumpAndSettle();

    expect(pageController.page, 0.0);
  });
}
