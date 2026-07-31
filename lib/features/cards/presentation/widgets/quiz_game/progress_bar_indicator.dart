import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/quiz_game/quiz_game_bloc.dart';

class ProgressBarIndicator extends StatelessWidget {
  const ProgressBarIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double dynamicMaxWidth = screenWidth * 0.85;
    return BlocBuilder<QuizGameBloc, QuizGameState>(
      builder: (context, state) {
        int question = (state is QuizGameIsFinish)
            ? (state.activeQuestion ?? 0)
            : 0;
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
              height: 8,
              width: dynamicMaxWidth,
            ),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorDark,
                borderRadius: BorderRadius.circular(10),
              ),
              height: 8,
              width: (dynamicMaxWidth * (question + 1) / 10),
            ),
          ],
        );
      },
    );
  }
}
