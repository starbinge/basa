import 'package:basa_app_project/features/cards/data/dao/cards_dao.dart';
import 'package:basa_app_project/features/cards/domain/entities/card_history_entity.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';
import 'package:basa_app_project/features/cards/domain/repositories/history_card_repo.dart';
import 'package:basa_app_project/features/cards/domain/usecases/get_start_end_date.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final CardsDao _cardsDao;
  final HistoryCardRepo _historyCardRepo;
  HistoryBloc(
    super.initialState, {
    required CardsDao cardsDao,
    required HistoryCardRepo historyCardRepo,
  }) : _historyCardRepo = historyCardRepo,
       _cardsDao = cardsDao {
    on<HistoryEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<getHistory>((card, emit) async {
      final int limit = 50;
      final DateTime now = DateTime.now();

      //Monthly Boundaries
      final int startMonth = getStartOfMonthEpoch(time: now);
      final int endMonth = getStartOfNextMonthEpoch(time: now);

      //Weekly Boundaries
      final int startWeek = getStartOfWeekEpoch(time: now);
      final int endWeek = getEndOfWeekEpoch(time: now);

      //Today Boundaries
      final int startToday = getStartOfTodayEpoch(time: now);
      final int endToday = getEndOfTodayEpoch(time: now);
      emit(HistoryIsLoading());
      try {
        final results = await Future.wait([
          _historyCardRepo.getWeeklyHistory(
            start: startWeek,
            end: endWeek,
            limit: limit,
            cardsDao: _cardsDao,
          ),
          _historyCardRepo.getMonthlyHistory(
            start: startMonth,
            end: endMonth,
            limit: limit,
            cardsDao: _cardsDao,
          ),

          _historyCardRepo.getTodayHistory(
            start: startToday,
            end: endToday,
            limit: limit,
            cardsDao: _cardsDao,
          ),
        ]);
        emit(
          HistoryIsFinished(
            histories: CardHistoryEntity(
              weeklyHistory: results[0],
              todayHistory: results[2],
              monthlyHistory: results[1],
            ),
          ),
        );
      } catch (e) {
        emit(HistoryIsError(errorMessage: e.toString()));
      }
    });
  }
}
