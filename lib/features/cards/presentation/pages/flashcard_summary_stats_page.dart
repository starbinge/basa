import 'package:basa_app_project/core/constants/screen_size.dart';
import 'package:basa_app_project/features/cards/domain/usecases/format_time_usecase.dart';
import 'package:basa_app_project/features/decks/presentation/bloc/fetching_deck/fetching_deck_bloc.dart';
import 'package:basa_app_project/features/decks/presentation/bloc/fetching_deck/fetching_deck_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FlashcardSummaryStatsPage extends StatefulWidget {
  const FlashcardSummaryStatsPage({
    super.key,
    required this.correctAnswer,
    required this.wrongAnswer,
    required this.timeSpent,
    required this.deckId,
  });

  final String correctAnswer;
  final String wrongAnswer;
  final String timeSpent;
  final String deckId;

  @override
  State<FlashcardSummaryStatsPage> createState() =>
      _FlashcardSummaryStatsPageState();
}

class _FlashcardSummaryStatsPageState extends State<FlashcardSummaryStatsPage> {
  @override
  void initState() {
    context.read<FetchingDeckBloc>().add(
      UpdateActiveHour(
        deckId: int.parse(widget.deckId),
        additionalHours: int.parse(widget.timeSpent),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final int totalCorrect = int.tryParse(widget.correctAnswer) ?? 0;
    final int totalWrong = int.tryParse(widget.wrongAnswer) ?? 0;
    final int totalQuestion = totalCorrect + totalWrong;
    final FormatTimeUseCase _formatTime = FormatTimeUseCase();

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: totalQuestion,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: context.screenHeight * 0.02,
                      mainAxisSpacing: context.screenWidth * 0.02,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (BuildContext context, indexItem) {
                      final bool isWrong = indexItem < totalWrong;

                      return RepaintBoundary(
                        child:
                            Container(
                              decoration: BoxDecoration(
                                border: isWrong
                                    ? Border.all(width: 1, color: Colors.white)
                                    : null,
                                borderRadius: BorderRadius.circular(100),
                                color: isWrong
                                    ? Colors.transparent
                                    : Colors.white,
                              ),
                            ).animate().fadeIn(
                              delay: Duration(milliseconds: indexItem * 300),
                            ),
                      );
                    },
                  ),
                ),
              ),

              Text(
                "$totalCorrect / $totalQuestion",
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  fontSize: context.screenWidth * 0.2,
                ),
              ),

              SizedBox(
                width: context.screenWidth / 2,
                child: Text(
                  "Questions were being correct answered",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: context.screenHeight * 0.02,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Time Spent: ${_formatTime.timeDividerFromSeconds(durations: widget.timeSpent)}",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w200,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
              Container(
                padding: EdgeInsets.all(context.screenWidth * 0.03),
                width: double.infinity,
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Go Back",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
