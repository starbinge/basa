import 'package:basa_app_project/features/cards/constants/enums/group_by_enum.dart';
import 'package:basa_app_project/features/cards/constants/enums/order_enums.dart';
import 'package:basa_app_project/features/cards/data/models/flashcard_statistic_model.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';
import 'package:basa_app_project/features/cards/domain/repositories/accuracy_card_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'card_accuracy_event.dart';
part 'card_accuracy_state.dart';

class CardAccuracyBloc extends Bloc<CardAccuracyEvent, CardAccuracyState> {
  final AccuracyCardRepo _accuracyCardRepo;

  CardAccuracyBloc({required AccuracyCardRepo accuracyCardRepo})
      : _accuracyCardRepo = accuracyCardRepo,
        super(CardAccuracyInitial()) {
    on<FetchAccuracySummary>(_onFetchSummary);
    on<FetchAccuracyDetail>(_onFetchDetail);
  }

  Future<void> _onFetchSummary(
    FetchAccuracySummary event,
    Emitter<CardAccuracyState> emit,
  ) async {
    emit(CardAccuracyLoading());
    try {
      final results = await Future.wait([
        _accuracyCardRepo.getSingleAccuracy(
          timeRange: GroupedTimeEnum.thisMonth,
        ),
        _accuracyCardRepo.getSingleAccuracy(
          timeRange: GroupedTimeEnum.previousMonth,
        ),
      ]);

      emit(
        AccuracySummaryLoaded(
          thisMonthAccuracy: results[0],
          previousMonthAccuracy: results[1],
        ),
      );
    } catch (e) {
      emit(CardAccuracyError(errorMessage: e.toString()));
    }
  }

  Future<void> _onFetchDetail(
    FetchAccuracyDetail event,
    Emitter<CardAccuracyState> emit,
  ) async {
    emit(CardAccuracyLoading());
    try {
      final now = DateTime.now();
      final DateTime startOfWeek = now.subtract(
        Duration(days: now.weekday - 1),
      );
      final int beginWeek = DateTime(
        startOfWeek.year,
        startOfWeek.month,
        startOfWeek.day,
      ).millisecondsSinceEpoch;
      final int endWeek = beginWeek + (7 * 24 * 60 * 60 * 1000);
      final int todayTime = DateTime(
        now.year,
        now.month,
        now.day,
      ).millisecondsSinceEpoch;
      final int tomorrowTime = DateTime(
        now.year,
        now.month,
        now.day + 1,
      ).millisecondsSinceEpoch;

      final results = await Future.wait([
        _accuracyCardRepo.getSingleAccuracy(
          timeRange: GroupedTimeEnum.thisMonth,
        ),
        _accuracyCardRepo.getSingleAccuracy(
          timeRange: GroupedTimeEnum.previousMonth,
        ),
        _accuracyCardRepo
            .getGroupedAccuracy(timeRange: GroupedTimeEnum.monthly)
            .first,
        _accuracyCardRepo
            .getGroupedAccuracy(timeRange: GroupedTimeEnum.weekly)
            .first,
        _accuracyCardRepo
            .getGroupedAccuracy(timeRange: GroupedTimeEnum.daily)
            .first,
        _accuracyCardRepo.getAccuracyTopCards(
          begin: _getStartOfMonthEpoch(now),
          end: _getStartOfNextMonthEpoch(now),
          orderBy: OrderEnums.desc,
        ),
        _accuracyCardRepo.getAccuracyTopCards(
          begin: beginWeek,
          end: endWeek,
          orderBy: OrderEnums.desc,
        ),
        _accuracyCardRepo.getAccuracyTopCards(
          begin: todayTime,
          end: tomorrowTime,
          orderBy: OrderEnums.desc,
        ),
        _accuracyCardRepo.getAccuracyTopCards(
          begin: _getStartOfMonthEpoch(now),
          end: _getStartOfNextMonthEpoch(now),
          orderBy: OrderEnums.asc,
        ),
        _accuracyCardRepo.getAccuracyTopCards(
          begin: beginWeek,
          end: endWeek,
          orderBy: OrderEnums.asc,
        ),
        _accuracyCardRepo.getAccuracyTopCards(
          begin: todayTime,
          end: tomorrowTime,
          orderBy: OrderEnums.asc,
        ),
      ]);

      emit(
        AccuracyDetailLoaded(
          thisMonthAccuracy: results[0] as DeckAccuracy,
          previousMonthAccuracy: results[1] as DeckAccuracy,
          monthlyAccuracy: results[2] as List<DeckAccuracy>,
          weeklyAccuracy: results[3] as List<DeckAccuracy>,
          dailyAccuracy: results[4] as List<DeckAccuracy>,
          top3MonthlyMostAccurate: results[5] as List<CardsDetailEntity>,
          top3WeeklyMostAccurate: results[6] as List<CardsDetailEntity>,
          top3TodayMostAccurate: results[7] as List<CardsDetailEntity>,
          top3MonthlyLeastAccurate: results[8] as List<CardsDetailEntity>,
          top3WeeklyLeastAccurate: results[9] as List<CardsDetailEntity>,
          top3TodayLeastAccurate: results[10] as List<CardsDetailEntity>,
        ),
      );
    } catch (e) {
      emit(CardAccuracyError(errorMessage: e.toString()));
    }
  }

  int _getStartOfMonthEpoch(DateTime time) =>
      DateTime(time.year, time.month, 1).millisecondsSinceEpoch;

  int _getStartOfNextMonthEpoch(DateTime time) =>
      DateTime(time.year, time.month + 1, 1).millisecondsSinceEpoch;
}
