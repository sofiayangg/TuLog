import 'package:flutter/material.dart';

import '../models/sleep_record.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key, required this.records});

  final List<SleepRecord> records;

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.nights_stay_outlined,
                size: 54,
                color: Color(0xFF8179D3),
              ),
              const SizedBox(height: 14),
              const Text(
                'Your sleep history will appear here.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF20294A),
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Save your first sleep record from the Tracker tab.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.blueGrey.shade600),
              ),
            ],
          ),
        ),
      );
    }

    final sortedRecords = [...records]
      ..sort((a, b) => b.date.compareTo(a.date));
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      itemCount: sortedRecords.length + 1,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              'Your sleep history',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: const Color(0xFF20294A),
                fontWeight: FontWeight.w700,
              ),
            ),
          );
        }

        final record = sortedRecords[index - 1];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 18,
                      color: Color(0xFF8179D3),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _formatDate(record.date),
                        style: const TextStyle(
                          color: Color(0xFF20294A),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      formatDuration(record.durationMinutes),
                      style: const TextStyle(
                        color: Color(0xFF8179D3),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _TimeDetail(
                        icon: Icons.bedtime_outlined,
                        label: 'Bedtime',
                        value: formatTime(record.bedtimeMinutes),
                      ),
                    ),
                    Expanded(
                      child: _TimeDetail(
                        icon: Icons.wb_sunny_outlined,
                        label: 'Wake-up',
                        value: formatTime(record.wakeTimeMinutes),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

class _TimeDetail extends StatelessWidget {
  const _TimeDetail({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 17, color: Colors.blueGrey.shade500),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(color: Colors.blueGrey.shade500, fontSize: 11),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                color: Color(0xFF20294A),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
