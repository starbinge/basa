import '../cards_detail_entity.dart';

class TimeConsumeEntity {
  final String timeLabel;
  final TimeUnit avgTime;
  final TimeUnit totalTime;

  TimeConsumeEntity({
    required this.timeLabel,
    required this.avgTime,
    required this.totalTime,
  });
}

class TimeUnit {
  final int hour;
  final int minute;
  final int seconds;

  const TimeUnit({required this.hour, required this.minute, required this.seconds});

  factory TimeUnit.fromMilliSeconds(int time) {
    return TimeUnit(
      hour: Duration(milliseconds: time).inHours,
      minute: Duration(milliseconds: time).inMinutes.remainder(60),
      seconds: Duration(milliseconds: time).inSeconds.remainder(60),
    );
  }

  TimeUnit normalized() {
    int totalSeconds = hour * 3600 + minute * 60 + seconds;
    return TimeUnit(
      hour: totalSeconds ~/ 3600,
      minute: (totalSeconds ~/ 60) % 60,
      seconds: totalSeconds % 60,
    );
  }

  String get formatted {
    if (hour > 0) {
      final double h = hour + minute / 60;
      final text = h.toStringAsFixed(1);
      return text.endsWith('.0') ? '${h.toInt()}h' : '${text}h';
    }
    if (minute > 0) return '${minute}m';
    return '${seconds}s';
  }
}

class TopCardsTimeConsumeEntity {
  final String timeLabel;
  final TimeUnit timeSpent;
  final CardsDetailEntity card;

  TopCardsTimeConsumeEntity({
    required this.timeLabel,
    required this.timeSpent,
    required this.card,
  });
}
