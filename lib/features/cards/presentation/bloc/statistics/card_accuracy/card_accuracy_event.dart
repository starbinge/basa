part of 'card_accuracy_bloc.dart';

@immutable
sealed class CardAccuracyEvent {}

class FetchAccuracySummary extends CardAccuracyEvent {}

class FetchAccuracyDetail extends CardAccuracyEvent {}
