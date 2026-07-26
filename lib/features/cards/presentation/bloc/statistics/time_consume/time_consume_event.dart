part of 'time_consume_bloc.dart';

@immutable
sealed class TimeConsumeEvent {}

class FetchWeeklyStreak extends TimeConsumeEvent {}

class FetchTimeConsumeDetail extends TimeConsumeEvent {}
