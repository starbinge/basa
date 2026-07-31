import 'package:basa_app_project/features/cards/constants/enums/quiz_game_enum.dart';

class QuizGameEntity {
  final int cid;
  final QuizGameEnum questionType;
  final String question;
  final String correctAnswer;
  final List<String> options;
  QuizGameEntity({
    required this.questionType,
    required this.question,
    required this.correctAnswer,
    required this.options,
    required this.cid,
  });
}
