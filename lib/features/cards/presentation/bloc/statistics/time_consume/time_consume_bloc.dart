import 'package:basa_app_project/features/cards/constants/enums/group_by_enum.dart';
import 'package:basa_app_project/features/cards/constants/enums/order_enums.dart';
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
    on<FetchWeeklyStreak>((event, emit) async {
      emit(TimeConsumeLoading());
      try {
        final streakData = await _timeConsumeRepo.getThisWeekStreakData();
        emit(StreakDataLoaded(streakData: streakData));
      } catch (e) {
        emit(TimeConsumeError(errorMessage: e.toString()));
      }
    });
    on<FetchTimeConsumeDetail>((event, emit) async {
      emit(TimeConsumeLoading());
      try {
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
              .getGroupedTimeConsume(timeRange: GroupedTimeEnum.daily)
              .first,
        ]);

        emit(
          TimeConsumeDetailLoaded(
            thisMonthTimeConsume: results[0] as TimeConsumeEntity,
            previousMonthTimeConsume: results[1] as TimeConsumeEntity,
            monthlyTimeConsume: results[2] as List<TimeConsumeEntity>,
            dailyTimeConsume: results[3] as List<TimeConsumeEntity>,
          ),
        );
      } catch (e) {
        emit(TimeConsumeError(errorMessage: e.toString()));
      }
    });
    on<GetTopCards>((event, emit) async {
      try {
        final results = await Future.wait([
          _timeConsumeRepo.getTimeConsumeTopCards(
            begin: event.begin,
            end: event.end,
            orderBy: OrderEnums.desc,
          ),
          _timeConsumeRepo.getTimeConsumeTopCards(
            begin: event.begin,
            end: event.end,
            orderBy: OrderEnums.asc,
          ),
          _timeConsumeRepo.getTotalCardsByTimeRange(
            begin: event.begin,
            end: event.end,
          ),
          _timeConsumeRepo.getAvgTimeByTimeRange(
            begin: event.begin,
            end: event.end,
          ),
          _timeConsumeRepo.getTotalTimeByTimeRange(
            begin: event.begin,
            end: event.end,
          ),
        ]);
        final currentState = state as TimeConsumeDetailLoaded;
        emit(
          currentState.copyWith(
            mostTimeConsumingCards:
                results[0] as List<TopCardsTimeConsumeEntity>,
            totalCard: results[2] as int,
            avgTime: results[3] as TimeUnit,
            totalTime: results[4] as TimeUnit,
          ),
        );
      } catch (e) {
        emit(TimeConsumeError(errorMessage: e.toString()));
      }
    });
  }
}
