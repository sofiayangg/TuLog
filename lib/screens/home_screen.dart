import 'package:flutter/material.dart';

import '../models/sleep_record.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.records,
    required this.onOpenTracker,
    required this.onOpenHistory,
  });

  final List<SleepRecord> records;
  final VoidCallback onOpenTracker;
  final VoidCallback onOpenHistory;

  static const _goalMinutes = 8 * 60;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    SleepRecord? todayRecord;
    for (final record in records) {
      if (record.isSameDay(today)) {
        todayRecord = record;
        break;
      }
    }
    final sleepMinutes = todayRecord?.durationMinutes ?? 0;
    final progress = (sleepMinutes / _goalMinutes).clamp(0.0, 1.0);
    final reachedGoal = sleepMinutes >= _goalMinutes;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome back',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: const Color(0xFF20294A),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'A little rest goes a long way.',
            style: TextStyle(color: Colors.blueGrey.shade600, fontSize: 15),
          ),
          const SizedBox(height: 20),
          _SleepSummaryCard(
            duration: todayRecord == null ? null : formatDuration(sleepMinutes),
            progress: progress,
            reachedGoal: reachedGoal,
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _QuickActionCard(
                  icon: Icons.bedtime_outlined,
                  title: 'Log sleep',
                  subtitle: 'Add a record',
                  onTap: onOpenTracker,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _QuickActionCard(
                  icon: Icons.history_rounded,
                  title: 'Sleep history',
                  subtitle:
                      '${records.length} ${records.length == 1 ? 'record' : 'records'}',
                  onTap: onOpenHistory,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Text(
            'A gentle reminder',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: const Color(0xFF20294A),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome, color: Color(0xFF8179D3)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'A calm, consistent bedtime can help you wake up feeling refreshed.',
                      style: TextStyle(
                        height: 1.4,
                        color: Colors.blueGrey.shade800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SleepSummaryCard extends StatelessWidget {
  const _SleepSummaryCard({
    required this.duration,
    required this.progress,
    required this.reachedGoal,
  });

  final String? duration;
  final double progress;
  final bool reachedGoal;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF20294A), Color(0xFF454D78)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.nightlight_round, color: Color(0xFFE6DFFF), size: 22),
              SizedBox(width: 8),
              Text(
                "TODAY'S SLEEP",
                style: TextStyle(
                  color: Color(0xFFD8D8F2),
                  fontSize: 12,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Spacer(),
              Icon(Icons.star, color: Color(0xFFE6DFFF), size: 14),
              SizedBox(width: 5),
              Icon(Icons.star, color: Color(0xFFBEB9EA), size: 10),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            duration ?? 'Not logged yet',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            reachedGoal
                ? 'You reached your 8-hour sleep goal!'
                : 'Your daily goal is 8 hours',
            style: const TextStyle(color: Color(0xFFD8D8F2), fontSize: 14),
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation(Color(0xFFC9C2FF)),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(progress * 100).round()}% of your goal',
            style: const TextStyle(color: Color(0xFFD8D8F2), fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: const Color(0xFF8179D3), size: 24),
              const SizedBox(height: 14),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF20294A),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: TextStyle(color: Colors.blueGrey.shade600, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
