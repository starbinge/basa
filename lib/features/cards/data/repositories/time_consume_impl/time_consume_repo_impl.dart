import 'package:intl/intl.dart';

import '../../../constants/enums/group_by_enum.dart';
import '../../../constants/enums/order_enums.dart';
import '../../../domain/entities/cards_detail_entity.dart';
import '../../../domain/entities/time_consume_entity/time_consume_entity.dart';
import '../../../domain/repositories/time_consume/time_consume_repo.dart';
import '../../../domain/usecases/time_range_generator_usecase.dart';
import '../../dao/time_consume_dao/time_consume_dao.dart';
import '../../models/time_consume_model/time_consume_model.dart';

class TimeConsumeRepoImpl implements TimeConsumeRepo {
  final TimeConsumeDao _timeConsumeDao;

  TimeConsumeRepoImpl({required TimeConsumeDao timeConsumeDao})
    : _timeConsumeDao = timeConsumeDao;

  @override
  Stream<List<TimeConsumeEntity>> getGroupedTimeConsume({
    required GroupedTimeEnum timeRange,
  }) {
    final DateTime now = DateTime.now();
    final rawStream = _timeConsumeDao.getGroupedTimeConsume(
      timeRange: timeRange,
    );

    return rawStream.map((models) {
      switch (timeRange) {
        case GroupedTimeEnum.daily:
          return _groupDaily(models, now);
        case GroupedTimeEnum.weekly:
          return _groupWeekly(models, now);
        case GroupedTimeEnum.monthly:
          return _groupMonthly(models, now);
        default:
          return [];
      }
    });
  }

  @override
  Future<TimeConsumeEntity> getSingleTimeConsume({
    required GroupedTimeEnum timeRange,
  }) async {
    final now = DateTime.now();
    final String timeLabel;
    final rawStream = _timeConsumeDao.getGroupedTimeConsume(timeRange: timeRange);
    final models = await rawStream.first;

    switch (timeRange) {
      case GroupedTimeEnum.thisMonth:
        timeLabel = DateFormat.MMMM('en_US').format(now);
      case GroupedTimeEnum.previousMonth:
        final lastMonth = DateTime(now.year, now.month - 1);
        timeLabel = DateFormat.MMMM('en_US').format(lastMonth);
      default:
        timeLabel = DateFormat.MMMM('en_US').format(now);
    }

    final totalTimeMs = models.fold<int>(0, (sum, m) => sum + m.timeSpent);
    final count = models.length;
    final avgTimeMs = count > 0 ? totalTimeMs ~/ count : 0;

    return TimeConsumeEntity(
      timeLabel: timeLabel,
      avgTime: TimeUnit.fromMilliSeconds(avgTimeMs),
      totalTime: TimeUnit.fromMilliSeconds(totalTimeMs),
    );
  }

  @override
  Future<List<TimeConsumeEntity>> getThisWeekStreakData() {
    return _timeConsumeDao.getThisWeekStreakData();
  }

  @override
  Future<List<CardsDetailEntity>> getTimeConsumeTopCards({
    required int begin,
    required int end,
    required OrderEnums orderBy,
  }) {
    return _timeConsumeDao.getTimeConsumeTopCards(
      begin: begin,
      end: end,
      orderBy: orderBy,
      limit: 3,
    );
  }

  List<TimeConsumeEntity> _groupDaily(
    List<TimeConsumeModel> models,
    DateTime now,
  ) {
    final buckets = getDailyObject<TimeConsumeModel>(
      year: now.year,
      month: now.month,
    );

    for (final model in models) {
      final day = DateTime.fromMillisecondsSinceEpoch(model.timeCode).day;
      if (buckets.containsKey(day)) {
        buckets[day]!.add(model);
      }
    }

    return buckets.entries.map((entry) {
      final totalTimeMs = entry.value.fold<int>(
        0,
        (sum, m) => sum + m.timeSpent,
      );
      final count = entry.value.length;
      final avgTimeMs = count > 0 ? totalTimeMs ~/ count : 0;

      return TimeConsumeEntity(
        timeLabel: '${entry.key}',
        avgTime: TimeUnit.fromMilliSeconds(avgTimeMs),
        totalTime: TimeUnit.fromMilliSeconds(totalTimeMs),
      );
    }).toList();
  }

  List<TimeConsumeEntity> _groupWeekly(
    List<TimeConsumeModel> models,
    DateTime now,
  ) {
    final buckets = getWeeklyObject<TimeConsumeModel>();
    final weekKeys = ['1w', '2w', '3w', '4w'];

    for (final model in models) {
      final day = DateTime.fromMillisecondsSinceEpoch(model.timeCode).day;
      final weekIndex = ((day - 1) ~/ 7).clamp(0, 3);
      buckets[weekKeys[weekIndex]]!.add(model);
    }

    return buckets.entries.map((entry) {
      final totalTimeMs = entry.value.fold<int>(
        0,
        (sum, m) => sum + m.timeSpent,
      );
      final count = entry.value.length;
      final avgTimeMs = count > 0 ? totalTimeMs ~/ count : 0;

      return TimeConsumeEntity(
        timeLabel: entry.key,
        avgTime: TimeUnit.fromMilliSeconds(avgTimeMs),
        totalTime: TimeUnit.fromMilliSeconds(totalTimeMs),
      );
    }).toList();
  }

  List<TimeConsumeEntity> _groupMonthly(
    List<TimeConsumeModel> models,
    DateTime now,
  ) {
    final buckets = getMonthlyObject<TimeConsumeModel>(now.year);

    for (final model in models) {
      final month =
          DateTime.fromMillisecondsSinceEpoch(model.timeCode).month;
      final monthName = DateFormat.MMMM('en_US').format(DateTime(now.year, month));
      if (buckets.containsKey(monthName)) {
        buckets[monthName]!.add(model);
      }
    }

    return buckets.entries.map((entry) {
      final totalTimeMs = entry.value.fold<int>(
        0,
        (sum, m) => sum + m.timeSpent,
      );
      final count = entry.value.length;
      final avgTimeMs = count > 0 ? totalTimeMs ~/ count : 0;

      return TimeConsumeEntity(
        timeLabel: entry.key,
        avgTime: TimeUnit.fromMilliSeconds(avgTimeMs),
        totalTime: TimeUnit.fromMilliSeconds(totalTimeMs),
      );
    }).toList();
  }
}
