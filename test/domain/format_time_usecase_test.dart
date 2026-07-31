import 'package:basa_app_project/features/cards/domain/usecases/format_time_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  group('FormatTimeUseCase.timeDividerFromSeconds', () {
    final useCase = FormatTimeUseCase();

    test('formats zero seconds', () {
      expect(useCase.timeDividerFromSeconds(durations: '0'), '0 : 0');
    });

    test('formats seconds only', () {
      expect(useCase.timeDividerFromSeconds(durations: '45'), '0 : 45');
    });

    test('zero-pads a single-digit minute', () {
      expect(useCase.timeDividerFromSeconds(durations: '65'), '01 : 5');
    });

    test('does not pad a two-digit minute', () {
      expect(useCase.timeDividerFromSeconds(durations: '3600'), '60 : 0');
      expect(useCase.timeDividerFromSeconds(durations: '3661'), '61 : 1');
    });
  });

  group('FormatTimeUseCase.gettimeNameFromEpoch', () {
    setUpAll(() async {
      await initializeDateFormatting('id_ID');
    });

    final useCase = FormatTimeUseCase();

    test('returns Indonesian month abbreviation', () {
      expect(
        useCase.gettimeNameFromEpoch(
          DateTime(2026, 1, 15).millisecondsSinceEpoch,
        ),
        'Jan',
      );
      expect(
        useCase.gettimeNameFromEpoch(
          DateTime(2026, 5, 15).millisecondsSinceEpoch,
        ),
        'Mei',
      );
      expect(
        useCase.gettimeNameFromEpoch(
          DateTime(2026, 8, 15).millisecondsSinceEpoch,
        ),
        'Agu',
      );
      expect(
        useCase.gettimeNameFromEpoch(
          DateTime(2026, 12, 15).millisecondsSinceEpoch,
        ),
        'Des',
      );
    });
  });
}
