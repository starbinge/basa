part of 'card_accuracy_bloc.dart';

@immutable
sealed class CardAccuracyEvent {}

class FetchAccuracySummary extends CardAccuracyEvent {}

class FetchAccuracyDetail extends CardAccuracyEvent {}

class FetchTop3Cards extends CardAccuracyEvent {
  final int begin;
  final int end;

  FetchTop3Cards({required this.begin, required this.end});
}
