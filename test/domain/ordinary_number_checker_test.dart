import 'package:basa_app_project/features/cards/domain/usecases/ordinary_number_checker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final OrdinaryNumberChecker checker = OrdinaryNumberChecker();

  int epochOfDay(int day) => DateTime(2026, 1, day).millisecondsSinceEpoch;

  group('OrdinaryNumberChecker', () {
    test('returns st suffix for 1, 21, 31', () {
      expect(checker.generateOrdinaryNumber(number: epochOfDay(1)), '1st');
      expect(checker.generateOrdinaryNumber(number: epochOfDay(21)), '21st');
      expect(checker.generateOrdinaryNumber(number: epochOfDay(31)), '31st');
    });

    test('returns nd suffix for 2 and 22', () {
      expect(checker.generateOrdinaryNumber(number: epochOfDay(2)), '2nd');
      expect(checker.generateOrdinaryNumber(number: epochOfDay(22)), '22nd');
    });

    test('returns rd suffix for 3 and 23', () {
      expect(checker.generateOrdinaryNumber(number: epochOfDay(3)), '3rd');
      expect(checker.generateOrdinaryNumber(number: epochOfDay(23)), '23rd');
    });

    test('returns th suffix for other numbers', () {
      expect(checker.generateOrdinaryNumber(number: epochOfDay(4)), '4th');
      expect(checker.generateOrdinaryNumber(number: epochOfDay(10)), '10th');
      expect(checker.generateOrdinaryNumber(number: epochOfDay(20)), '20th');
      expect(checker.generateOrdinaryNumber(number: epochOfDay(30)), '30th');
    });

    test('returns th suffix for 11, 12 and 13', () {
      expect(checker.generateOrdinaryNumber(number: epochOfDay(11)), '11th');
      expect(checker.generateOrdinaryNumber(number: epochOfDay(12)), '12th');
      expect(checker.generateOrdinaryNumber(number: epochOfDay(13)), '13th');
    });
  });
}
