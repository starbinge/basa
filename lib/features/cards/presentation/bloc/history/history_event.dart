part of 'history_bloc.dart';

@immutable
sealed class HistoryEvent {}

final class getHistory extends HistoryEvent {
  getHistory();
}
