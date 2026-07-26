import 'package:intl/intl.dart';

import '../../../constants/enums/group_by_enum.dart';
import '../../../constants/enums/order_enums.dart';
import '../../../data/models/flashcard_statistic_model.dart';
import '../../../domain/entities/cards_detail_entity.dart';
import '../../../domain/repositories/accuracy_card_repo.dart';
import '../../../domain/usecases/time_range_generator_usecase.dart';
import '../../dao/accuracy_dao/accuracy_dao.dart';
import '../../models/accuracy_model/accuracy_model.dart';

class AccuracyRepoImpl implements AccuracyCardRepo {
  final AccuracyDao _accuracyDao;

  AccuracyRepoImpl({required AccuracyDao accuracyDao})
    : _accuracyDao = accuracyDao;

  @override
  Future<DeckAccuracy> getSingleAccuracy({
    required GroupedTimeEnum timeRange,
  }) async {
    final DateTime now = DateTime.now();
    final String timeLabel;

    switch (timeRange) {
      case GroupedTimeEnum.thisMonth:
        timeLabel = DateFormat.MMMM('en_US').format(now);
      case GroupedTimeEnum.previousMonth:
        final DateTime lastMonth = DateTime(now.year, now.month - 1);
        timeLabel = DateFormat.MMMM('en_US').format(lastMonth);
      default:
        timeLabel = DateFormat.MMMM('en_US').format(now);
    }

    final rawStream = _accuracyDao.getAccuracyData(timeRange: timeRange);
    final models = await rawStream.first;

    final total = models.length;
    final correct = models.where((m) => m.ease == 3).length;
    final accuracy = total > 0 ? (correct * 100 / total).round() : 0;

    return DeckAccuracy(timeName: timeLabel, accuracyNumber: accuracy);
  }

  @override
  Stream<List<DeckAccuracy>> getGroupedAccuracy({
    required GroupedTimeEnum timeRange,
  }) {
    final DateTime now = DateTime.now();
    final rawStream = _accuracyDao.getAccuracyData(timeRange: timeRange);

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

  List<DeckAccuracy> _groupDaily(
    List<AccuracyModel> models,
    DateTime now,
  ) {
    final buckets = getDailyObject<AccuracyModel>(
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
      final total = entry.value.length;
      final correct = entry.value.where((m) => m.ease == 3).length;
      final accuracy = total > 0 ? (correct * 100 / total).round() : 0;

      return DeckAccuracy(
        timeName: '${entry.key}',
        accuracyNumber: accuracy,
      );
    }).toList();
  }

  List<DeckAccuracy> _groupWeekly(
    List<AccuracyModel> models,
    DateTime now,
  ) {
    final buckets = getWeeklyObject<AccuracyModel>();
    final weekKeys = ['1w', '2w', '3w', '4w'];

    for (final model in models) {
      final day = DateTime.fromMillisecondsSinceEpoch(model.timeCode).day;
      final weekIndex = ((day - 1) ~/ 7).clamp(0, 3);
      buckets[weekKeys[weekIndex]]!.add(model);
    }

    return buckets.entries.map((entry) {
      final total = entry.value.length;
      final correct = entry.value.where((m) => m.ease == 3).length;
      final accuracy = total > 0 ? (correct * 100 / total).round() : 0;

      return DeckAccuracy(
        timeName: entry.key,
        accuracyNumber: accuracy,
      );
    }).toList();
  }

  List<DeckAccuracy> _groupMonthly(
    List<AccuracyModel> models,
    DateTime now,
  ) {
    final buckets = getMonthlyObject<AccuracyModel>(now.year);

    for (final model in models) {
      final month =
          DateTime.fromMillisecondsSinceEpoch(model.timeCode).month;
      final monthName = DateFormat.MMMM('en_US').format(DateTime(now.year, month));
      if (buckets.containsKey(monthName)) {
        buckets[monthName]!.add(model);
      }
    }

    return buckets.entries.map((entry) {
      final total = entry.value.length;
      final correct = entry.value.where((m) => m.ease == 3).length;
      final accuracy = total > 0 ? (correct * 100 / total).round() : 0;

      return DeckAccuracy(
        timeName: entry.key,
        accuracyNumber: accuracy,
      );
    }).toList();
  }

  @override
  Future<List<CardsDetailEntity>> getAccuracyTopCards({
    required int begin,
    required int end,
    required OrderEnums orderBy,
  }) async {
    return _accuracyDao.getAccuracyTopCards(
      begin: begin,
      end: end,
      orderBy: orderBy,
    );
  }
}
