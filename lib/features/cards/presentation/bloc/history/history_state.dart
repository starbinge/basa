part of 'history_bloc.dart';

@immutable
sealed class HistoryState {}

final class HistoryIsLoading extends HistoryState {}

final class HistoryIsError extends HistoryState {
  final String errorMessage;

  HistoryIsError({required this.errorMessage});
}

final class HistoryIsFinished extends HistoryState {
  final CardHistoryEntity histories;

  HistoryIsFinished({required this.histories});
}
