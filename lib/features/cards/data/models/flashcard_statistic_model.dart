import 'package:basa_app_project/features/cards/data/models/fetching_cards_model.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';

class DeckAccuracyStats {
  // ini tujuannya untuk menyimpan
  final DeckAccuracy thisMonthDeckAccuracy;
  final DeckAccuracy previousMonthDeckAccuracy;
  final List<DeckAccuracy> weeklyList;
  final List<DeckAccuracy> monthlyList;
  final List<CardsDetailEntity> top3MostAccurate;
  final List<CardsDetailEntity> top3LeastAccurate;

  DeckAccuracyStats({
    required this.thisMonthDeckAccuracy,
    required this.previousMonthDeckAccuracy,
    required this.weeklyList,
    required this.monthlyList,
    required this.top3MostAccurate,
    required this.top3LeastAccurate,
  });

  factory DeckAccuracyStats.fromMap(
    Map<String, dynamic> map,
  ) => DeckAccuracyStats(
    thisMonthDeckAccuracy: DeckAccuracy.fromMap(map['thisMonthDeckAccuracy']),
    previousMonthDeckAccuracy: DeckAccuracy.fromMap(
      map['previousMonthDeckAccuracy'],
    ),
    weeklyList: (map['weeklyList'] as List<DeckAccuracy>)
        .map((data) => DeckAccuracy.fromMap(data as Map<String, dynamic>))
        .toList(),
    monthlyList: (map['monthlyList'] as List<DeckAccuracy>)
        .map((data) => DeckAccuracy.fromMap(data as Map<String, dynamic>))
        .toList(),
    top3MostAccurate: (map['top3MostAccurate'] as List<CardsDetailEntity>)
        .map((data) => CardsDetailEntity.fromMap(data as Map<String, dynamic>))
        .toList(),
    top3LeastAccurate: (map['top3LeastAccurate'] as List<CardsDetailEntity>)
        .map((data) => CardsDetailEntity.fromMap(data as Map<String, dynamic>))
        .toList(),
  );

  Map<String, dynamic> toMap() => {
    'thisMonthDeckAccuracy': thisMonthDeckAccuracy.toMap(),
    'previousMonthDeckAccuracy': previousMonthDeckAccuracy.toMap(),
    'weeklyList': weeklyList.map((data) => data.toMap()),
    'monthlyList': monthlyList.map((data) => data.toMap()),
    'top3MostAccurate': top3MostAccurate.map((data) => data.toMap()),
    'top3LeastAccurate': top3LeastAccurate.map((data) => data.toMap()),
  };
}

class DeckAccuracy {
  final String monthName;
  final int accuracyNumber;

  //
  DeckAccuracy({required this.monthName, required this.accuracyNumber});

  factory DeckAccuracy.fromMap(Map<String, dynamic> map) => DeckAccuracy(
    monthName: map['monthName'] as String,
    accuracyNumber: (map['accuracyNumber'] as num).toInt(),
  );

  Map<String, dynamic> toMap() => {
    'monthName': monthName,
    'accuracyNumber': accuracyNumber,
  };
}

class DeckTimeConsume {
  final String monthName;
  final int avgTime;
  final int totalTime;

  DeckTimeConsume({
    required this.monthName,
    required this.avgTime,
    required this.totalTime,
  });

  factory DeckTimeConsume.fromMap(Map<String, dynamic> map) => DeckTimeConsume(
    monthName: map['monthName'] as String,
    avgTime: (map['avgTime'] as num).toInt(),
    totalTime: map['totalTime'] as int,
  );

  Map<String, dynamic> toMap() => {
    'monthName': monthName,
    'avgTime': avgTime,
    'totalTime': totalTime,
  };
}

class DeckTimeConsumeStats {
  final DeckTimeConsume thisMonthDeckTimeConsume;
  final DeckTimeConsume previousMonthDeckTimeConsume;
  final List<DeckTimeConsume> weeklyList;
  final List<DeckTimeConsume> monthlyList;
  final List<CardsDetailEntity> longestTimeCard;
  final List<CardsDetailEntity> shortestTimeCard;

  DeckTimeConsumeStats({
    required this.longestTimeCard,
    required this.shortestTimeCard,
    required this.thisMonthDeckTimeConsume,
    required this.previousMonthDeckTimeConsume,
    required this.weeklyList,
    required this.monthlyList,
  });

  factory DeckTimeConsumeStats.fromMap(Map<String, dynamic> map) =>
      DeckTimeConsumeStats(
        thisMonthDeckTimeConsume: DeckTimeConsume.fromMap(
          map['thisMonthDeckTimeConsume'],
        ),
        previousMonthDeckTimeConsume: DeckTimeConsume.fromMap(
          map['previousMonthDeckTimeConsume'],
        ),
        weeklyList: (map['weeklyList'] as List)
            .map((e) => DeckTimeConsume.fromMap(e))
            .toList(),
        monthlyList: (map['monthlyList'] as List)
            .map((e) => DeckTimeConsume.fromMap(e))
            .toList(),
        longestTimeCard: (map['longestTimeCard'] as List)
            .map((e) => CardsDetailEntity.fromMap(e))
            .toList(),
        shortestTimeCard: (map['shortestTimeCard'] as List)
            .map((e) => CardsDetailEntity.fromMap(e))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
    'thisMonthDeckTimeConsume': thisMonthDeckTimeConsume.toMap(),
    'previousMonthDeckTimeConsume': previousMonthDeckTimeConsume.toMap(),
    'weeklyList': weeklyList.map((e) => e.toMap()).toList(),
    'monthlyList': monthlyList.map((e) => e.toMap()).toList(),
    'longestTimeCard': longestTimeCard.map((e) => e.toMap()).toList(),
    'shortestTimeCard': shortestTimeCard.map((e) => e.toMap()).toList(),
  };
}

class MonthlyAccuracy {
  final List<DeckAccuracy> MostAccurate;
  final List<DeckAccuracy> LeastAccurate;

  MonthlyAccuracy({required this.MostAccurate, required this.LeastAccurate});

  factory MonthlyAccuracy.fromMap(Map<String, dynamic> map) => MonthlyAccuracy(
    MostAccurate: (map['MostAccurate'] as List)
        .map((e) => DeckAccuracy.fromMap(e))
        .toList(),
    LeastAccurate: (map['LeastAccurate'] as List)
        .map((e) => DeckAccuracy.fromMap(e))
        .toList(),
  );

  Map<String, dynamic> toMap() => {
    'MostAccurate': MostAccurate.map((e) => e.toMap()).toList(),
    'LeastAccurate': LeastAccurate.map((e) => e.toMap()).toList(),
  };
}

class WeeklyAccuracy {
  final List<DeckAccuracy> MostAccurate;
  final List<DeckAccuracy> LeastAccurate;

  WeeklyAccuracy({required this.MostAccurate, required this.LeastAccurate});

  factory WeeklyAccuracy.fromMap(Map<String, dynamic> map) => WeeklyAccuracy(
    MostAccurate: (map['MostAccurate'] as List)
        .map((e) => DeckAccuracy.fromMap(e))
        .toList(),
    LeastAccurate: (map['LeastAccurate'] as List)
        .map((e) => DeckAccuracy.fromMap(e))
        .toList(),
  );

  Map<String, dynamic> toMap() => {
    'MostAccurate': MostAccurate.map((e) => e.toMap()).toList(),
    'LeastAccurate': LeastAccurate.map((e) => e.toMap()).toList(),
  };
}
