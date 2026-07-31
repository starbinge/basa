import 'package:basa_app_project/features/cards/constants/enums/group_by_enum.dart';
import 'package:basa_app_project/features/cards/constants/enums/order_enums.dart';
import 'package:basa_app_project/features/cards/data/models/flashcard_statistic_model.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';
import 'package:basa_app_project/features/cards/domain/entities/time_consume_entity/time_consume_entity.dart';
import 'package:basa_app_project/features/cards/domain/repositories/accuracy_card_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'card_accuracy_event.dart';
part 'card_accuracy_state.dart';

class CardAccuracyBloc extends Bloc<CardAccuracyEvent, CardAccuracyState> {
  final AccuracyCardRepo _accuracyCardRepo;

  CardAccuracyBloc({required AccuracyCardRepo accuracyCardRepo})
    : _accuracyCardRepo = accuracyCardRepo,
      super(CardAccuracyInitial()) {
    on<FetchAccuracySummary>((event, emit) async {
      emit(CardAccuracyLoading());

      try {
        final thisMonthStream = _accuracyCardRepo.getSingleAccuracy(
          timeRange: GroupedTimeEnum.thisMonth,
        );
        final previousMonthStream = _accuracyCardRepo.getSingleAccuracy(
          timeRange: GroupedTimeEnum.previousMonth,
        );

        final combinedStream = Rx.combineLatest2(
          thisMonthStream,
          previousMonthStream,
          (thisMonthData, previousMonthData) =>
              (thisMonthData, previousMonthData),
        );

        await emit.forEach(
          combinedStream,
          onData: (data) {
            return AccuracySummaryLoaded(
              thisMonthAccuracy: data.$1,
              previousMonthAccuracy: data.$2,
            );
          },
          onError: (error, stackTrace) {
            return CardAccuracyError(errorMessage: error.toString());
          },
        );
      } catch (e) {
        emit(CardAccuracyError(errorMessage: e.toString()));
      }
    });
    on<FetchAccuracyDetail>((event, emit) async {
      emit(CardAccuracyLoading());
      try {
        final results = await Future.wait([
          _accuracyCardRepo
              .getSingleAccuracy(timeRange: GroupedTimeEnum.thisMonth)
              .first,
          _accuracyCardRepo
              .getGroupedAccuracy(timeRange: GroupedTimeEnum.monthly)
              .first,

          _accuracyCardRepo
              .getGroupedAccuracy(timeRange: GroupedTimeEnum.daily)
              .first,
          _accuracyCardRepo
              .getSingleAccuracy(timeRange: GroupedTimeEnum.previousMonth)
              .first,
        ]);

        emit(
          AccuracyDetailLoaded(
            thisMonthAccuracy: results[0] as DeckAccuracy,
            monthlyAccuracy: results[1] as List<DeckAccuracy>,
            dailyAccuracy: results[2] as List<DeckAccuracy>,
            previousMonthAccuracy: results[3] as DeckAccuracy,
          ),
        );
      } catch (e) {
        emit(CardAccuracyError(errorMessage: e.toString()));
      }
    });
    on<FetchTop3Cards>((event, emit) async {
      try {
        final results = await Future.wait([
          _accuracyCardRepo.getAccuracyTopCards(
            begin: event.begin,
            end: event.end,
            orderBy: OrderEnums.asc,
          ),
          _accuracyCardRepo.getAvgAccuracyByTimeRange(
            begin: event.begin,
            end: event.end,
          ),
          _accuracyCardRepo.getTotalCardsByTimeRange(
            begin: event.begin,
            end: event.end,
          ),
          _accuracyCardRepo.getTotalTimeByTimeRange(
            begin: event.begin,
            end: event.end,
          ),
        ]);
        final currentState = state as AccuracyDetailLoaded;
        emit(
          currentState.copyWith(
            avgAccuracy: results[1] as int,
            totalCard: results[2] as int,
            totalTime: results[3] as TimeUnit,
            top3LeastAccurate: results[0] as List<CardsDetailEntity>,
          ),
        );
      } catch (e) {
        emit(CardAccuracyError(errorMessage: e.toString()));
      }
    });
  }
}
