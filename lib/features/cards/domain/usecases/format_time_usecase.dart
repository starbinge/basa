import 'package:intl/intl.dart';

class FormatTimeUseCase {
  String timeDividerFromSeconds({required String durations}) {
    final Duration _durations = Duration(seconds: int.tryParse(durations)!);
    String? _finalTime;
    int _inMinutes = _durations.inMinutes;
    int _inSeconds = _durations.inSeconds % 60;

    if (_inMinutes > 0) {
      _finalTime = "${_inMinutes} : ${_inSeconds}";
    } else
      (_finalTime = "0 : ${_inSeconds}");
    return _finalTime;
  }

  String getMonthNameFromEpoch(int epochMs) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(epochMs);
    String monthName = DateFormat.MMM('id_ID').format(date);

    return monthName;
  }
}
