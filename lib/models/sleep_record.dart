class SleepRecord {
  const SleepRecord({
    required this.date,
    required this.bedtimeMinutes,
    required this.wakeTimeMinutes,
  });

  final DateTime date;
  final int bedtimeMinutes;
  final int wakeTimeMinutes;

  int get durationMinutes =>
      calculateDurationMinutes(bedtimeMinutes, wakeTimeMinutes);

  bool isSameDay(DateTime other) =>
      date.year == other.year &&
      date.month == other.month &&
      date.day == other.day;

  Map<String, Object> toJson() => {
    'date': DateTime(date.year, date.month, date.day).toIso8601String(),
    'bedtimeMinutes': bedtimeMinutes,
    'wakeTimeMinutes': wakeTimeMinutes,
  };

  factory SleepRecord.fromJson(Map<String, dynamic> json) {
    final date = DateTime.parse(json['date'] as String);
    final bedtime = json['bedtimeMinutes'] as int;
    final wakeTime = json['wakeTimeMinutes'] as int;
    _validateTime(bedtime);
    _validateTime(wakeTime);
    return SleepRecord(
      date: DateTime(date.year, date.month, date.day),
      bedtimeMinutes: bedtime,
      wakeTimeMinutes: wakeTime,
    );
  }

  static int calculateDurationMinutes(int bedtimeMinutes, int wakeTimeMinutes) {
    _validateTime(bedtimeMinutes);
    _validateTime(wakeTimeMinutes);
    if (wakeTimeMinutes == bedtimeMinutes) return 0;
    if (wakeTimeMinutes < bedtimeMinutes) {
      return 24 * 60 - bedtimeMinutes + wakeTimeMinutes;
    }
    return wakeTimeMinutes - bedtimeMinutes;
  }

  static void _validateTime(int minutes) {
    if (minutes < 0 || minutes >= 24 * 60) {
      throw RangeError.range(minutes, 0, 24 * 60 - 1, 'minutes');
    }
  }
}

String formatTime(int minutes) {
  final hour = minutes ~/ 60;
  final minute = minutes % 60;
  final period = hour >= 12 ? 'PM' : 'AM';
  final displayHour = hour % 12 == 0 ? 12 : hour % 12;
  return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
}

String formatDuration(int minutes) {
  final hours = minutes ~/ 60;
  final remainingMinutes = minutes % 60;
  return '${hours}h ${remainingMinutes}m';
}
