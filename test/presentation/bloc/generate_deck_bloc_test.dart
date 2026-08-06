import 'package:basa_app_project/core/data/initial_database/initial_database.dart';
import 'package:basa_app_project/core/errors/input_errors.dart';
import 'package:basa_app_project/features/decks/domain/repositories/deck_repository.dart';
import 'package:basa_app_project/features/decks/domain/repositories/generate_deck_repo.dart';
import 'package:basa_app_project/features/decks/presentation/bloc/generate_deck/generate_deck_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeGenerateDeckRepo implements GenerateDeckRepo {
  _FakeGenerateDeckRepo(this.result);

  Map<String, dynamic> Function() result;

  @override
  Future<Map<String, dynamic>> generateDeck({
    required Map<String, dynamic> requestData,
  }) async {
    return result();
  }
}

class _FakeDeckRepository implements DeckRepository {
  _FakeDeckRepository(this.generateHandler);

  Future<void> Function() generateHandler;

  @override
  Future<void> generateDeck({
    required Map<String, dynamic> jsonData,
    required String deckName,
    required int colorDeck,
    required String countryDeck,
  }) async {
    return generateHandler();
  }

  @override
  Future<List<ImportedDeckData>> getAll() async => [];

  @override
  Future<bool> isDeckExists(String deckName) async => false;

  @override
  Future<void> importDeck({
    required String deckName,
    required String deckFilePath,
    required int deckColor,
    required String deckLanguage,
    String explanationRolePlay = '',
  }) async {}

  @override
  Future<int> updatingActiveHour({
    required int deckId,
    required int additionalHours,
  }) async =>
      0;
}

GenerateDeck generateEvent() => GenerateDeck(
  deckName: 'Korean',
  colorDeck: 123,
  countryDeck: 'Korea',
  defaultLanguage: 'Indonesia',
  rolePlay: 'A student',
  targetLang: 'Korea',
  difficulty: 'beginner',
);

void main() {
  test('emits GenerateDeckIsFinished on success', () async {
    final bloc = GenerateDeckBloc(
      generateDeckRepo: _FakeGenerateDeckRepo(() => {'listCards': []}),
      deckRepository: _FakeDeckRepository(() async {}),
    );

    final state = bloc.stream.firstWhere(
      (s) => s is GenerateDeckIsFinished,
    );
    bloc.add(generateEvent());

    expect(await state, isA<GenerateDeckIsFinished>());
    await bloc.close();
  });

  test('emits GenerateDeckIsError when API fails', () async {
    final bloc = GenerateDeckBloc(
      generateDeckRepo: _FakeGenerateDeckRepo(
        () => throw Exception('API down'),
      ),
      deckRepository: _FakeDeckRepository(() async {}),
    );

    final state = bloc.stream.firstWhere((s) => s is GenerateDeckIsError);
    bloc.add(generateEvent());

    final errorState = await state;
    expect(errorState, isA<GenerateDeckIsError>());
    expect((errorState as GenerateDeckIsError).errorMessage, 'Exception: API down');
    await bloc.close();
  });

  test('emits GenerateDeckIsExist when the deck already exists', () async {
    final bloc = GenerateDeckBloc(
      generateDeckRepo: _FakeGenerateDeckRepo(() => {'listCards': []}),
      deckRepository: _FakeDeckRepository(
        () async => throw DeckAlreadyExistsException(),
      ),
    );

    final state = bloc.stream.firstWhere((s) => s is GenerateDeckIsExist);
    bloc.add(generateEvent());

    expect(await state, isA<GenerateDeckIsExist>());
    await bloc.close();
  });
}
