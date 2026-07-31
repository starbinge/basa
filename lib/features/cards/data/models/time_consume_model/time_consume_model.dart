import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';
import 'package:basa_app_project/features/cards/domain/entities/time_consume_entity/time_consume_entity.dart';
import 'package:basa_app_project/features/cards/domain/usecases/ordinary_number_checker.dart';

class TimeConsumeModel {
  final int timeCode;
  final int timeSpent;

  TimeConsumeModel({required this.timeCode, required this.timeSpent});

  factory TimeConsumeModel.fromMap(Map<String, dynamic> map) {
    return TimeConsumeModel(
      timeCode: map['timeCode'] as int,
      timeSpent: map['timeSpent'] as int,
    );
  }

  Map<String, dynamic> toMap() => {
    'timeCode': timeCode,
    'timeSpent': timeSpent,
  };
}

class TopCardsTimeConsumeModel {
  final int timeCode;
  final int timeSpent;
  final CardsDetailEntity card;

  TopCardsTimeConsumeModel({
    required this.timeCode,
    required this.card,
    required this.timeSpent,
  });

  factory TopCardsTimeConsumeModel.fromMAp(Map<String, dynamic> map) {
    return TopCardsTimeConsumeModel(
      timeCode: map['timeCode'] as int,
      card: map['card'] as CardsDetailEntity,
      timeSpent: ['timeSpent'] as int,
    );
  }

  Map<String, dynamic> toMap() => {
    'timeCode': timeCode,
    'card': card,
    'timeSpent': timeSpent,
  };

  TopCardsTimeConsumeEntity toEntity() {
    final int hour = Duration(milliseconds: timeSpent).inHours;
    final int minute = Duration(
      milliseconds: timeSpent,
    ).inMinutes.remainder(60);
    final int seconds = Duration(
      milliseconds: timeSpent,
    ).inSeconds.remainder(60);
    final timeLabel = OrdinaryNumberChecker().generateOrdinaryNumber(
      number: timeCode,
    );
    return TopCardsTimeConsumeEntity(
      timeLabel: timeLabel,
      timeSpent: TimeUnit(hour: hour, minute: minute, seconds: seconds),
      card: card,
    );
  }
}
