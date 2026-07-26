class TimeConsumeModel {
  final int timeCode;
  final int timeSpent;

  TimeConsumeModel({required this.timeCode, required this.timeSpent});

  factory TimeConsumeModel.fromMap(Map<String, dynamic> map) {
    return TimeConsumeModel(
      timeCode: map['timeCode'] as int,
      timeSpent: map['timeSpent'] as int,
    );
  }

  Map<String, dynamic> toMap() => {
    'timeCode': timeCode,
    'timeSpent': timeSpent,
  };
}
