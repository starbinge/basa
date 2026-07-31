part of 'history_bloc.dart';

@immutable
sealed class HistoryState {}


final class HistoryInitial extends HistoryState {}


final class HistoryIsLoading extends HistoryState {}

final class HistoryIsError extends HistoryState {
  final String errorMessage;

  HistoryIsError({required this.errorMessage});
}

final class HistoryIsFinished extends HistoryState {
  final HistoryEntity today;
  final HistoryEntity weekly;
  final HistoryEntity monthly;

  HistoryIsFinished({required this.today, required this.weekly, required this.monthly});
}
