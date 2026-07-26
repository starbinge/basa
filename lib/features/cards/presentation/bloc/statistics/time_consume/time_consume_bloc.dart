import 'package:basa_app_project/features/cards/constants/enums/group_by_enum.dart';
import 'package:basa_app_project/features/cards/constants/enums/order_enums.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';
import 'package:basa_app_project/features/cards/domain/entities/time_consume_entity/time_consume_entity.dart';
import 'package:basa_app_project/features/cards/domain/repositories/time_consume/time_consume_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'time_consume_event.dart';
part 'time_consume_state.dart';

class TimeConsumeBloc extends Bloc<TimeConsumeEvent, TimeConsumeState> {
  final TimeConsumeRepo _timeConsumeRepo;

  TimeConsumeBloc({required TimeConsumeRepo timeConsumeRepo})
      : _timeConsumeRepo = timeConsumeRepo,
        super(TimeConsumeInitial()) {
    on<FetchWeeklyStreak>(_onFetchWeeklyStreak);
    on<FetchTimeConsumeDetail>(_onFetchDetail);
  }

  Future<void> _onFetchWeeklyStreak(
    FetchWeeklyStreak event,
    Emitter<TimeConsumeState> emit,
  ) async {
    emit(TimeConsumeLoading());
    try {
      final streakData = await _timeConsumeRepo.getThisWeekStreakData();
      emit(StreakDataLoaded(streakData: streakData));
    } catch (e) {
      emit(TimeConsumeError(errorMessage: e.toString()));
    }
  }

  Future<void> _onFetchDetail(
    FetchTimeConsumeDetail event,
    Emitter<TimeConsumeState> emit,
  ) async {
    emit(TimeConsumeLoading());
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
        _timeConsumeRepo.getSingleTimeConsume(
          timeRange: GroupedTimeEnum.thisMonth,
        ),
        _timeConsumeRepo.getSingleTimeConsume(
          timeRange: GroupedTimeEnum.previousMonth,
        ),
        _timeConsumeRepo
            .getGroupedTimeConsume(timeRange: GroupedTimeEnum.monthly)
            .first,
        _timeConsumeRepo
            .getGroupedTimeConsume(timeRange: GroupedTimeEnum.weekly)
            .first,
        _timeConsumeRepo
            .getGroupedTimeConsume(timeRange: GroupedTimeEnum.daily)
            .first,
        _timeConsumeRepo.getTimeConsumeTopCards(
          begin: _getStartOfMonthEpoch(now),
          end: _getStartOfNextMonthEpoch(now),
          orderBy: OrderEnums.desc,
        ),
        _timeConsumeRepo.getTimeConsumeTopCards(
          begin: beginWeek,
          end: endWeek,
          orderBy: OrderEnums.desc,
        ),
        _timeConsumeRepo.getTimeConsumeTopCards(
          begin: todayTime,
          end: tomorrowTime,
          orderBy: OrderEnums.desc,
        ),
        _timeConsumeRepo.getTimeConsumeTopCards(
          begin: _getStartOfMonthEpoch(now),
          end: _getStartOfNextMonthEpoch(now),
          orderBy: OrderEnums.asc,
        ),
        _timeConsumeRepo.getTimeConsumeTopCards(
          begin: beginWeek,
          end: endWeek,
          orderBy: OrderEnums.asc,
        ),
        _timeConsumeRepo.getTimeConsumeTopCards(
          begin: todayTime,
          end: tomorrowTime,
          orderBy: OrderEnums.asc,
        ),
      ]);

      emit(
        TimeConsumeDetailLoaded(
          thisMonthTimeConsume: results[0] as TimeConsumeEntity,
          previousMonthTimeConsume: results[1] as TimeConsumeEntity,
          monthlyTimeConsume: results[2] as List<TimeConsumeEntity>,
          weeklyTimeConsume: results[3] as List<TimeConsumeEntity>,
          dailyTimeConsume: results[4] as List<TimeConsumeEntity>,
          top3MonthlyMostTimeConsume:
              results[5] as List<CardsDetailEntity>,
          top3WeeklyMostTimeConsume:
              results[6] as List<CardsDetailEntity>,
          top3TodayMostTimeConsume:
              results[7] as List<CardsDetailEntity>,
          top3MonthlyLeastTimeConsume:
              results[8] as List<CardsDetailEntity>,
          top3WeeklyLeastTimeConsume:
              results[9] as List<CardsDetailEntity>,
          top3TodayLeastTimeConsume:
              results[10] as List<CardsDetailEntity>,
        ),
      );
    } catch (e) {
      emit(TimeConsumeError(errorMessage: e.toString()));
    }
  }

  int _getStartOfMonthEpoch(DateTime time) =>
      DateTime(time.year, time.month, 1).millisecondsSinceEpoch;

  int _getStartOfNextMonthEpoch(DateTime time) =>
      DateTime(time.year, time.month + 1, 1).millisecondsSinceEpoch;
}
