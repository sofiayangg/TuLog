import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/sleep_record.dart';

class SleepStorage {
  static const _recordsKey = 'sleep_records';

  Future<List<SleepRecord>> loadRecords() async {
    final preferences = await SharedPreferences.getInstance();
    final storedRecords = preferences.getString(_recordsKey);
    if (storedRecords == null) return [];

    final decoded = jsonDecode(storedRecords) as List<dynamic>;
    final records =
        decoded
            .map(
              (item) =>
                  SleepRecord.fromJson(Map<String, dynamic>.from(item as Map)),
            )
            .toList()
          ..sort((a, b) => b.date.compareTo(a.date));
    return records;
  }

  Future<void> saveRecord(SleepRecord record) async {
    final records = await loadRecords();
    final updatedRecords = [
      record,
      ...records.where((saved) => !saved.isSameDay(record.date)),
    ]..sort((a, b) => b.date.compareTo(a.date));

    final preferences = await SharedPreferences.getInstance();
    final encoded = jsonEncode(
      updatedRecords.map((item) => item.toJson()).toList(),
    );
    final wasSaved = await preferences.setString(_recordsKey, encoded);
    if (!wasSaved) {
      throw Exception(
        'The sleep record could not be written to local storage.',
      );
    }
  }
}
