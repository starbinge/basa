import 'package:basa_app_project/features/decks/presentation/widgets/deck_input_page_widgets/difficulty_input_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _Harness extends StatefulWidget {
  const _Harness({
    required this.initialPage,
    required this.initialDifficulty,
    required this.pageController,
    this.onSelect,
  });

  final int initialPage;
  final String initialDifficulty;
  final PageController pageController;
  final ValueChanged<String>? onSelect;

  @override
  State<_Harness> createState() => _HarnessState();
}

class _HarnessState extends State<_Harness> {
  late String _selectedDifficulty;

  @override
  void initState() {
    super.initState();
    _selectedDifficulty = widget.initialDifficulty;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: PageView(
          controller: widget.pageController,
          children: [
            const ColoredBox(color: Colors.red),
            DifficultyInputPage(
              theme: Theme.of(context),
              pageController: widget.pageController,
              selectedDifficulty: _selectedDifficulty,
              onSelect: (value) {
                setState(() => _selectedDifficulty = value);
                widget.onSelect?.call(value);
              },
            ),
            const ColoredBox(color: Colors.green),
          ],
        ),
      ),
    );
  }
}

void main() {
  testWidgets('renders title and all difficulty options', (tester) async {
    final pageController = PageController(initialPage: 1);
    addTearDown(pageController.dispose);

    await tester.pumpWidget(
      _Harness(
        initialPage: 1,
        initialDifficulty: '',
        pageController: pageController,
      ),
    );
    await tester.pump(const Duration(milliseconds: 1000));

    expect(find.text('Choose your difficulty'), findsOneWidget);
    for (final difficulty in DifficultyInputPage.difficulties) {
      expect(find.text(difficulty), findsOneWidget);
    }
    expect(find.text('Back'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
  });

  testWidgets('Next button is disabled until a difficulty is selected', (
    tester,
  ) async {
    final pageController = PageController(initialPage: 1);
    addTearDown(pageController.dispose);

    await tester.pumpWidget(
      _Harness(
        initialPage: 1,
        initialDifficulty: '',
        pageController: pageController,
      ),
    );
    await tester.pump(const Duration(milliseconds: 1000));

    final nextButton = tester.widget<TextButton>(
      find.ancestor(of: find.text('Next'), matching: find.byType(TextButton)),
    );
    expect(nextButton.onPressed, isNull);

    await tester.tap(find.text('beginner'));
    await tester.pumpAndSettle();

    final enabledNextButton = tester.widget<TextButton>(
      find.ancestor(of: find.text('Next'), matching: find.byType(TextButton)),
    );
    expect(enabledNextButton.onPressed, isNotNull);
  });

  testWidgets('reports the selected difficulty through onSelect', (tester) async {
    final pageController = PageController(initialPage: 1);
    addTearDown(pageController.dispose);
    String? selected;

    await tester.pumpWidget(
      _Harness(
        initialPage: 1,
        initialDifficulty: '',
        pageController: pageController,
        onSelect: (value) => selected = value,
      ),
    );
    await tester.pump(const Duration(milliseconds: 1000));

    await tester.tap(find.text('advanced'));
    await tester.pumpAndSettle();

    expect(selected, 'advanced');
  });

  testWidgets(
    'Next navigates to the following page when a difficulty is selected',
    (tester) async {
      final pageController = PageController(initialPage: 1);
      addTearDown(pageController.dispose);

      await tester.pumpWidget(
        _Harness(
          initialPage: 1,
          initialDifficulty: 'beginner',
          pageController: pageController,
        ),
      );
      await tester.pump(const Duration(milliseconds: 1000));

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      expect(pageController.page, 2.0);
    },
  );

  testWidgets('Back navigates to the previous page', (tester) async {
    final pageController = PageController(initialPage: 1);
    addTearDown(pageController.dispose);

    await tester.pumpWidget(
      _Harness(
        initialPage: 1,
        initialDifficulty: '',
        pageController: pageController,
      ),
    );
    await tester.pump(const Duration(milliseconds: 1000));

    await tester.tap(find.text('Back'));
    await tester.pumpAndSettle();

    expect(pageController.page, 0.0);
  });
}
