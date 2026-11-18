import 'package:flutter/material.dart';

import '../models/sleep_record.dart';

class TrackerScreen extends StatefulWidget {
  const TrackerScreen({
    super.key,
    required this.onSave,
    required this.isSaving,
  });

  final Future<void> Function(SleepRecord record) onSave;
  final bool isSaving;

  @override
  State<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> {
  TimeOfDay _bedtime = const TimeOfDay(hour: 22, minute: 30);
  TimeOfDay _wakeTime = const TimeOfDay(hour: 6, minute: 30);

  int get _bedtimeMinutes => _bedtime.hour * 60 + _bedtime.minute;
  int get _wakeTimeMinutes => _wakeTime.hour * 60 + _wakeTime.minute;
  int get _durationMinutes =>
      SleepRecord.calculateDurationMinutes(_bedtimeMinutes, _wakeTimeMinutes);

  Future<void> _chooseTime({required bool bedtime}) async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: bedtime ? _bedtime : _wakeTime,
      helpText: bedtime ? 'Select bedtime' : 'Select wake-up time',
    );
    if (selectedTime == null || !mounted) return;
    setState(() {
      if (bedtime) {
        _bedtime = selectedTime;
      } else {
        _wakeTime = selectedTime;
      }
    });
  }

  Future<void> _save() async {
    if (_durationMinutes == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Choose two different sleep times.')),
      );
      return;
    }

    final now = DateTime.now();
    final record = SleepRecord(
      date: DateTime(now.year, now.month, now.day),
      bedtimeMinutes: _bedtimeMinutes,
      wakeTimeMinutes: _wakeTimeMinutes,
    );

    try {
      await widget.onSave(record);
    } on Exception catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save your record: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Track your sleep',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: const Color(0xFF20294A),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Choose when you went to bed and woke up.',
            style: TextStyle(color: Colors.blueGrey.shade600, fontSize: 15),
          ),
          const SizedBox(height: 22),
          _TimePickerCard(
            icon: Icons.nightlight_round,
            title: 'Bedtime',
            time: _bedtime.format(context),
            onTap: () => _chooseTime(bedtime: true),
          ),
          const SizedBox(height: 14),
          _TimePickerCard(
            icon: Icons.wb_sunny_outlined,
            title: 'Wake-up time',
            time: _wakeTime.format(context),
            onTap: () => _chooseTime(bedtime: false),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  const Icon(Icons.schedule_rounded, color: Color(0xFF8179D3)),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Total sleep',
                      style: TextStyle(
                        color: Color(0xFF20294A),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    formatDuration(_durationMinutes),
                    style: const TextStyle(
                      color: Color(0xFF20294A),
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: widget.isSaving ? null : _save,
              icon: widget.isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save_outlined),
              label: Text(widget.isSaving ? 'Saving...' : 'Save sleep record'),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF20294A),
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Saving another record for today will replace today’s entry.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.blueGrey.shade600, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _TimePickerCard extends StatelessWidget {
  const _TimePickerCard({
    required this.icon,
    required this.title,
    required this.time,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String time;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0EEFF),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(icon, color: const Color(0xFF8179D3)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF20294A),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                time,
                style: const TextStyle(
                  color: Color(0xFF20294A),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.edit_outlined,
                size: 18,
                color: Color(0xFF8179D3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
