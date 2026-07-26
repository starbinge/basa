import 'package:basa_app_project/features/cards/constants/enums/group_by_enum.dart';
import 'package:basa_app_project/features/cards/domain/entities/history_entity/history_entity.dart';
import 'package:basa_app_project/features/cards/domain/repositories/history_card_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final HistoryCardRepo _historyCardRepo;

  HistoryBloc({required HistoryCardRepo historyCardRepo})
    : _historyCardRepo = historyCardRepo,
      super(HistoryInitial()) {
    on<getHistory>((card, emit) async {
      try {
        emit(HistoryIsLoading());
        final results = await Future.wait([
          _historyCardRepo.getHistoryByTimeRange(
            groupBy: GroupedTimeEnum.today,
          ),
          _historyCardRepo.getHistoryByTimeRange(
            groupBy: GroupedTimeEnum.weekly,
          ),
          _historyCardRepo.getHistoryByTimeRange(
            groupBy: GroupedTimeEnum.monthly,
          ),
        ]);
        emit(
          HistoryIsFinished(
            today: results[0],
            weekly: results[1],
            monthly: results[2],
          ),
        );
      } catch (error) {
        emit(HistoryIsError(errorMessage: error.toString()));
      }
    });
  }
}
