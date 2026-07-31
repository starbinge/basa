import 'package:basa_app_project/core/errors/input_errors.dart';
import 'package:basa_app_project/core/utils/file_picker.dart';
import 'package:basa_app_project/features/decks/domain/repositories/deck_repository.dart';
import 'package:bloc/bloc.dart';

import 'deck_import_event.dart';
import 'deck_import_state.dart';

class DeckImportBloc extends Bloc<DeckImportEvent, DeckImportState> {
  final DeckRepository _repository;
  final FilePickerService _filePickerService;

  DeckImportBloc({
    required DeckRepository repository,
    required FilePickerService filePicker,
  }) : _repository = repository,
       _filePickerService = filePicker,
       super(
         const DeckImportState(
           filePath: "",
           isLoading: false,
           isFinished: false,
           isError: false,
           errorMessage: "",
           isDeckExist: false,
         ),
       ) {
    on<SelectFile>((event, emit) async {
      final String result = await _filePickerService.getFilePath();
      if (result.isEmpty) return;
      emit(state.copyWith(filePath: result));
    });
    on<ImportDeck>((event, emit) async {
      emit(state.copyWith(isLoading: true, isFinished: false, isError: false));
      try {
        await Future.delayed(const Duration(seconds: 2));
        await _repository.importDeck(
          deckName: event.deckName,
          deckFilePath: event.deckFilePath,
          deckLanguage: event.deckLanguage,
          deckColor: event.deckColor,
        );
        emit(
          state.copyWith(isLoading: false, isFinished: true, isError: false),
        );
      } on DeckAlreadyExistsException {
        emit(
          state.copyWith(
            isError: true,
            errorMessage: "Deck already exist",
            isDeckExist: true,
            isLoading: false,
            isFinished: true,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            isError: true,
            errorMessage: e.toString(),
            isDeckExist: false,
            isLoading: false,
            isFinished: true,
          ),
        );
      }
    });
  }
}
