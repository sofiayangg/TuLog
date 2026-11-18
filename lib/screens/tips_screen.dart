import 'package:flutter/material.dart';

class TipsScreen extends StatelessWidget {
  const TipsScreen({super.key});

  static const _tips = [
    (
      Icons.schedule_rounded,
      'Keep a routine',
      'Try to go to bed and wake up around the same time each day.',
    ),
    (
      Icons.phone_android_rounded,
      'Take a screen break',
      'Put away bright screens a little while before bedtime.',
    ),
    (
      Icons.coffee_outlined,
      'Go easy on caffeine',
      'Avoid coffee and energy drinks late in the day.',
    ),
    (
      Icons.spa_outlined,
      'Wind down gently',
      'Try reading, stretching, or slow breathing to relax.',
    ),
    (
      Icons.bed_outlined,
      'Make your room restful',
      'A cool, quiet, and comfortable room can help you sleep.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        Text(
          'Sleep tips',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: const Color(0xFF20294A),
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Small habits can make bedtime feel easier.',
          style: TextStyle(color: Colors.blueGrey.shade600, fontSize: 15),
        ),
        const SizedBox(height: 16),
        for (final tip in _tips) ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0EEFF),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(tip.$1, color: const Color(0xFF8179D3)),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tip.$2,
                          style: const TextStyle(
                            color: Color(0xFF20294A),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          tip.$3,
                          style: TextStyle(
                            color: Colors.blueGrey.shade600,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}
