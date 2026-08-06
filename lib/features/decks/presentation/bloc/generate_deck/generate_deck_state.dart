part of 'generate_deck_bloc.dart';

@immutable
sealed class GenerateDeckState {}

final class GenerateDeckInitial extends GenerateDeckState {}

final class GenerateDeckLoading extends GenerateDeckState {}

final class GenerateDeckIsFinished extends GenerateDeckState {}

final class GenerateDeckIsExist extends GenerateDeckState {}

final class GenerateDeckIsError extends GenerateDeckState {
  final String errorMessage;

  GenerateDeckIsError({required this.errorMessage});
}
