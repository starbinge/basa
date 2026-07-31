part of 'time_consume_bloc.dart';

@immutable
sealed class TimeConsumeEvent {}

class FetchWeeklyStreak extends TimeConsumeEvent {}

class FetchTimeConsumeDetail extends TimeConsumeEvent {}

class GetTopCards extends TimeConsumeEvent {
  final int begin;
  final int end;

  GetTopCards({required this.begin, required this.end});
}
