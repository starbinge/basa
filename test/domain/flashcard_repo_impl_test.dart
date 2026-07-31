import 'package:basa_app_project/features/cards/constants/enums/flashcard_answer_enum.dart';
import 'package:basa_app_project/features/cards/data/repositories/flashcard_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Anchor date is 2026-01-01 (getDateConstanta). Injecting "now" at
  // 2026-01-15 gives a deterministic deltaTime of 14 days.
  FlashcardRepoImpl repoWithNow(DateTime now) {
    return FlashcardRepoImpl(now: () => now);
  }

  group('generateNewFactorValue', () {
    final repo = repoWithNow(DateTime(2026, 1, 15));

    test('correct answer adds 15 when answered within 3 seconds', () {
      expect(
        repo.generateNewFactorValue(
          answer: FlashcardAnswerEnum.correct,
          vF: 200,
          vT: 1000,
        ),
        215,
      );
      expect(
        repo.generateNewFactorValue(
          answer: FlashcardAnswerEnum.correct,
          vF: 200,
          vT: 3000,
        ),
        215,
      );
    });

    test('correct answer adds 10 when answered within 3-7 seconds', () {
      expect(
        repo.generateNewFactorValue(
          answer: FlashcardAnswerEnum.correct,
          vF: 200,
          vT: 5000,
        ),
        210,
      );
      expect(
        repo.generateNewFactorValue(
          answer: FlashcardAnswerEnum.correct,
          vF: 200,
          vT: 7000,
        ),
        210,
      );
    });

    test('correct answer adds only 1 when answered after 7 seconds', () {
      expect(
        repo.generateNewFactorValue(
          answer: FlashcardAnswerEnum.correct,
          vF: 200,
          vT: 9000,
        ),
        201,
      );
    });

    test('wrong answer subtracts 20 when answered within 7 seconds', () {
      expect(
        repo.generateNewFactorValue(
          answer: FlashcardAnswerEnum.wrong,
          vF: 200,
          vT: 5000,
        ),
        180,
      );
    });

    test('wrong answer subtracts 30 when answered after 7 seconds', () {
      expect(
        repo.generateNewFactorValue(
          answer: FlashcardAnswerEnum.wrong,
          vF: 200,
          vT: 9000,
        ),
        170,
      );
    });

    test('factor never drops below 130', () {
      expect(
        repo.generateNewFactorValue(
          answer: FlashcardAnswerEnum.wrong,
          vF: 130,
          vT: 5000,
        ),
        130,
      );
      expect(
        repo.generateNewFactorValue(
          answer: FlashcardAnswerEnum.wrong,
          vF: 100,
          vT: 9000,
        ),
        130,
      );
    });
  });

  group('generateNewDueValue', () {
    test('correct answer computes due relative to the injected now', () {
      final repo = repoWithNow(DateTime(2026, 1, 15));

      final due = repo.generateNewDueValue(
        answer: FlashcardAnswerEnum.correct,
        vF: 200,
        vT: 1000,
      );

      // newVf = 215, increment = (3 * 215 / 100).round() = 6, deltaTime = 14.
      expect(due, 20);
    });

    test('wrong answer computes a smaller due increment', () {
      final repo = repoWithNow(DateTime(2026, 1, 15));

      final due = repo.generateNewDueValue(
        answer: FlashcardAnswerEnum.wrong,
        vF: 200,
        vT: 9000,
      );

      // newVf = 170, increment = (1.5 * 170 / 100).round() = 3, deltaTime = 14.
      expect(due, 17);
    });

    test('grows as the injected now moves further from the anchor', () {
      final repoJan = repoWithNow(DateTime(2026, 1, 15));
      final repoMar = repoWithNow(DateTime(2026, 3, 1));

      final dueJan = repoJan.generateNewDueValue(
        answer: FlashcardAnswerEnum.correct,
        vF: 200,
        vT: 1000,
      );
      final dueMar = repoMar.generateNewDueValue(
        answer: FlashcardAnswerEnum.correct,
        vF: 200,
        vT: 1000,
      );

      expect(dueJan, 20);
      expect(dueMar, 65); // deltaTime of 59 days + same 6-day increment.
    });
  });

  group('generateFactorToRepsRatio', () {
    test('ratio is factor/100 divided by reps+1', () {
      final repo = repoWithNow(DateTime(2026, 1, 15));

      expect(repo.generateFactorToRepsRatio(vF: 200, vR: 0), 2.0);
      expect(repo.generateFactorToRepsRatio(vF: 200, vR: 3), 0.5);
      expect(repo.generateFactorToRepsRatio(vF: 150, vR: 1), 0.75);
    });
  });

  group('generateQueueValue', () {
    test('is computed from the due increment regardless of now', () {
      final repoJan = repoWithNow(DateTime(2026, 1, 15));
      final repoMar = repoWithNow(DateTime(2026, 3, 1));

      final queueJan = repoJan.generateQueueValue(
        answer: FlashcardAnswerEnum.correct,
        vF: 200,
        vR: 0,
        vT: 1000,
      );
      final queueMar = repoMar.generateQueueValue(
        answer: FlashcardAnswerEnum.correct,
        vF: 200,
        vR: 0,
        vT: 1000,
      );

      expect(queueJan, 120000);
      expect(queueMar, 120000);
    });

    test('correct fast answers produce higher urgency than wrong slow ones', () {
      final repo = repoWithNow(DateTime(2026, 1, 15));

      final fastCorrect = repo.generateQueueValue(
        answer: FlashcardAnswerEnum.correct,
        vF: 200,
        vR: 0,
        vT: 1000,
      );
      final slowWrong = repo.generateQueueValue(
        answer: FlashcardAnswerEnum.wrong,
        vF: 200,
        vR: 1,
        vT: 9000,
      );

      expect(fastCorrect, greaterThan(slowWrong));
    });
  });
}
