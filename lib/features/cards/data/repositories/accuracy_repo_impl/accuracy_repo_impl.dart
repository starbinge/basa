import 'package:basa_app_project/core/data/generated_database/generated_database.dart';
import 'package:basa_app_project/features/cards/domain/entities/time_consume_entity/time_consume_entity.dart';
import 'package:basa_app_project/features/cards/domain/usecases/get_start_end_date.dart';
import 'package:intl/intl.dart';

import '../../../constants/enums/group_by_enum.dart';
import '../../../constants/enums/order_enums.dart';
import '../../../data/models/flashcard_statistic_model.dart';
import '../../../domain/entities/cards_detail_entity.dart';
import '../../../domain/repositories/accuracy_card_repo.dart';
import '../../../domain/usecases/time_range_generator_usecase.dart';
import '../../models/accuracy_model/accuracy_model.dart';

class AccuracyRepoImpl implements AccuracyCardRepo {
  final GeneratedDeckDao _generatedDeckDao;

  AccuracyRepoImpl({required GeneratedDeckDao generatedDeckDao})
    : _generatedDeckDao = generatedDeckDao;

  @override
  Stream<DeckAccuracy> getSingleAccuracy({required GroupedTimeEnum timeRange}) {
    final DateTime now = DateTime.now();
    final String timeLabel;

    switch (timeRange) {
      case GroupedTimeEnum.thisMonth:
        timeLabel = DateFormat.MMMM('en_US').format(now);
      case GroupedTimeEnum.previousMonth:
        final int lastMonth = getStartOfPreviousMonthEpoch(time: now);
        timeLabel = DateFormat.MMMM(
          'en_US',
        ).format(DateTime.fromMillisecondsSinceEpoch(lastMonth));
      default:
        timeLabel = DateFormat.MMMM('en_US').format(now);
    }

    final rawStream = _generatedDeckDao.getAccuracyData(timeRange: timeRange);

    return rawStream.map((data) {
      final int totalCards = data.length;
      final int correctAnswer = data.where((card) => card.ease == 3).length;
      final int accuracyNumber = totalCards > 0
          ? (correctAnswer * 100 / totalCards).round()
          : 0;
      return DeckAccuracy(timeName: timeLabel, accuracyNumber: accuracyNumber);
    });
  }

  @override
  Stream<List<DeckAccuracy>> getGroupedAccuracy({
    required GroupedTimeEnum timeRange,
  }) {
    final DateTime now = DateTime.now();
    final rawStream = _generatedDeckDao.getAccuracyData(timeRange: timeRange);

    return rawStream.map((models) {
      switch (timeRange) {
        case GroupedTimeEnum.daily:
          return _groupDaily(models, now);
        case GroupedTimeEnum.monthly:
          return _groupMonthly(models, now);
        default:
          return [];
      }
    });
  }

  List<DeckAccuracy> _groupDaily(List<AccuracyModel> models, DateTime now) {
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

      return DeckAccuracy(timeName: '${entry.key}', accuracyNumber: accuracy);
    }).toList();
  }

  List<DeckAccuracy> _groupMonthly(List<AccuracyModel> models, DateTime now) {
    final buckets = getMonthlyObject<AccuracyModel>(now.year);

    for (final model in models) {
      final month = DateTime.fromMillisecondsSinceEpoch(model.timeCode).month;
      final monthName = DateFormat.MMMM(
        'en_US',
      ).format(DateTime(now.year, month));
      if (buckets.containsKey(monthName)) {
        buckets[monthName]!.add(model);
      }
    }

    return buckets.entries.map((entry) {
      final total = entry.value.length;
      final correct = entry.value.where((m) => m.ease == 3).length;
      final accuracy = total > 0 ? (correct * 100 / total).round() : 0;

      return DeckAccuracy(timeName: entry.key, accuracyNumber: accuracy);
    }).toList();
  }

  @override
  Future<List<CardsDetailEntity>> getAccuracyTopCards({
    required int begin,
    required int end,
    required OrderEnums orderBy,
  }) async {
    return await _generatedDeckDao.getMostInaccurateCards(
      begin: begin,
      end: end,
      orderBy: orderBy,
      limit: 3,
    );
  }

  @override
  Future<int> getAvgAccuracyByTimeRange({
    required begin,
    required end,
  }) async {
    return await _generatedDeckDao.getAverageNumber(
      begin: begin,
      end: end,
    );
  }

  @override
  Future<int> getTotalCardsByTimeRange({required begin, required end}) async {
    return await _generatedDeckDao.getReviewedCardsCount(
      begin: begin,
      end: end,
    );
  }

  @override
  Future<TimeUnit> getTotalTimeByTimeRange({required begin, required end}) async {
    return await _generatedDeckDao.getTotalTimeByTimeRange(
      begin: begin,
      end: end,
    );
  }
}
