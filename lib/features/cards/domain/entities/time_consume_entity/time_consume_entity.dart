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

  TimeUnit({required this.hour, required this.minute, required this.seconds});

  factory TimeUnit.fromMilliSeconds(int time) {
    return TimeUnit(
      hour: Duration(milliseconds: time).inHours,
      minute: Duration(milliseconds: time).inMinutes.remainder(60),
      seconds: Duration(milliseconds: time).inSeconds.remainder(60),
    );
  }
}
