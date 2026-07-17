class TimeEntity {
  final String hours;
  final String minutes;
  final String seconds;

  TimeEntity({
    required this.hours,
    required this.minutes,
    required this.seconds,
  });
}

class TimeConsumeStatsEntity {
  final TimeEntity avgTime;
  final TimeEntity totalTime;
  TimeConsumeStatsEntity({required this.avgTime, required this.totalTime});

  factory TimeConsumeStatsEntity.fromMillieSeconds({
    required int timeAvg,
    required int totalTime,
  }) {
    final Duration durationAvg = Duration(milliseconds: timeAvg);
    final Duration durationTotal = Duration(milliseconds: totalTime);

    //Duration Average Numbers
    final int avgHour = durationAvg.inHours;
    final int avgMinutes = durationAvg.inMinutes.remainder(60);
    final int avgSeconds = durationAvg.inSeconds.remainder(60);

    //Duration Total Numbers
    final int totalHour = durationTotal.inHours;
    final int totalMinutes = durationTotal.inMinutes.remainder(60);
    final int totalSeconds = durationTotal.inSeconds.remainder(60);

    return TimeConsumeStatsEntity(
      avgTime: TimeEntity(
        hours: avgHour.toString().padLeft(2, "0"),
        minutes: avgMinutes.toString().padLeft(2, "0"),
        seconds: avgSeconds.toString().padLeft(2, "0"),
      ),
      totalTime: TimeEntity(
        hours: totalHour.toString().padLeft(2, "0"),
        minutes: totalMinutes.toString().padLeft(2, "0"),
        seconds: totalSeconds.toString().padLeft(2, "0"),
      ),
    );
  }
}
