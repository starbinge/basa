import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';

class DeckAccuracyStats {
  final DeckAccuracy thisMonthDeckAccuracy;
  final DeckAccuracy previousMonthDeckAccuracy;
  final List<DeckAccuracy> weeklyList;
  final List<DeckAccuracy> monthlyList;
  final List<DeckAccuracy> dailyAccuracyList;
  final List<CardsDetailEntity> top3TodayMostAccurate;
  final List<CardsDetailEntity> top3TodayLeastAccurate;
  final List<CardsDetailEntity> top3WeeklyMostAccurate;
  final List<CardsDetailEntity> top3WeeklyLeastAccurate;
  final List<CardsDetailEntity> top3MonthlyMostAccurate;
  final List<CardsDetailEntity> top3MonthlyLeastAccurate;

  DeckAccuracyStats({
    required this.thisMonthDeckAccuracy,
    required this.previousMonthDeckAccuracy,
    required this.weeklyList,
    required this.monthlyList,
    required this.dailyAccuracyList,
    required this.top3TodayMostAccurate,
    required this.top3TodayLeastAccurate,
    required this.top3WeeklyMostAccurate,
    required this.top3WeeklyLeastAccurate,
    required this.top3MonthlyMostAccurate,
    required this.top3MonthlyLeastAccurate,
  });

  factory DeckAccuracyStats.fromMap(Map<String, dynamic> map) =>
      DeckAccuracyStats(
        thisMonthDeckAccuracy: DeckAccuracy.fromMap(
          map['thisMonthDeckAccuracy'],
        ),
        previousMonthDeckAccuracy: DeckAccuracy.fromMap(
          map['previousMonthDeckAccuracy'],
        ),
        weeklyList: (map['weeklyList'] as List<DeckAccuracy>)
            .map((data) => DeckAccuracy.fromMap(data as Map<String, dynamic>))
            .toList(),
        monthlyList: (map['monthlyList'] as List<DeckAccuracy>)
            .map((data) => DeckAccuracy.fromMap(data as Map<String, dynamic>))
            .toList(),
        dailyAccuracyList: (map['dailyAccuracyList'] as List<DeckAccuracy>)
            .map((data) => DeckAccuracy.fromMap(data as Map<String, dynamic>))
            .toList(),
        top3TodayMostAccurate:
            (map['top3TodayMostAccurate'] as List<CardsDetailEntity>)
                .map(
                  (data) =>
                      CardsDetailEntity.fromMap(data as Map<String, dynamic>),
                )
                .toList(),
        top3TodayLeastAccurate:
            (map['top3TodayLeastAccurate'] as List<CardsDetailEntity>)
                .map(
                  (data) =>
                      CardsDetailEntity.fromMap(data as Map<String, dynamic>),
                )
                .toList(),
        top3WeeklyMostAccurate:
            (map['top3WeeklyMostAccurate'] as List<CardsDetailEntity>)
                .map(
                  (data) =>
                      CardsDetailEntity.fromMap(data as Map<String, dynamic>),
                )
                .toList(),
        top3WeeklyLeastAccurate:
            (map['top3WeeklyLeastAccurate'] as List<CardsDetailEntity>)
                .map(
                  (data) =>
                      CardsDetailEntity.fromMap(data as Map<String, dynamic>),
                )
                .toList(),
        top3MonthlyMostAccurate:
            (map['top3MonthlyMostAccurate'] as List<CardsDetailEntity>)
                .map(
                  (data) =>
                      CardsDetailEntity.fromMap(data as Map<String, dynamic>),
                )
                .toList(),
        top3MonthlyLeastAccurate:
            (map['top3MonthlyLeastAccurate'] as List<CardsDetailEntity>)
                .map(
                  (data) =>
                      CardsDetailEntity.fromMap(data as Map<String, dynamic>),
                )
                .toList(),
      );

  Map<String, dynamic> toMap() => {
    'thisMonthDeckAccuracy': thisMonthDeckAccuracy.toMap(),
    'previousMonthDeckAccuracy': previousMonthDeckAccuracy.toMap(),
    'weeklyList': weeklyList.map((data) => data.toMap()),
    'monthlyList': monthlyList.map((data) => data.toMap()),
    'dailyAccuracyList': dailyAccuracyList.map((data) => data.toMap()),
    'top3TodayMostAccurate': top3TodayMostAccurate.map((data) => data.toMap()),
    'top3TodayLeastAccurate': top3TodayLeastAccurate.map(
      (data) => data.toMap(),
    ),
    'top3WeeklyMostAccurate': top3WeeklyMostAccurate.map(
      (data) => data.toMap(),
    ),
    'top3WeeklyLeastAccurate': top3WeeklyLeastAccurate.map(
      (data) => data.toMap(),
    ),
    'top3MonthlyMostAccurate': top3MonthlyMostAccurate.map(
      (data) => data.toMap(),
    ),
    'top3MonthlyLeastAccurate': top3MonthlyLeastAccurate.map(
      (data) => data.toMap(),
    ),
  };
}

class DeckAccuracy {
  final String timeName;
  final int accuracyNumber;

  //
  DeckAccuracy({required this.timeName, required this.accuracyNumber});

  factory DeckAccuracy.fromMap(Map<String, dynamic> map) => DeckAccuracy(
    timeName: map['timeName'] as String,
    accuracyNumber: (map['accuracyNumber'] as num).toInt(),
  );

  Map<String, dynamic> toMap() => {
    'timeName': timeName,
    'accuracyNumber': accuracyNumber,
  };
}

class DeckTimeConsume {
  final String timeName;
  final int avgTime;
  final int totalTime;

  DeckTimeConsume({
    required this.timeName,
    required this.avgTime,
    required this.totalTime,
  });

  factory DeckTimeConsume.fromMap(Map<String, dynamic> map) => DeckTimeConsume(
    timeName: map['timeName'] as String,
    avgTime: (map['avgTime'] as num).toInt(),
    totalTime: map['totalTime'] as int,
  );

  Map<String, dynamic> toMap() => {
    'timeName': timeName,
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
