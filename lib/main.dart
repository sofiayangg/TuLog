import 'package:flutter/material.dart';

import 'models/sleep_record.dart';
import 'screens/history_screen.dart';
import 'screens/home_screen.dart';
import 'screens/tips_screen.dart';
import 'screens/tracker_screen.dart';
import 'services/sleep_storage.dart';

void main() {
  runApp(const TuLogApp());
}

class TuLogApp extends StatelessWidget {
  const TuLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF20294A);
    const lavender = Color(0xFF8179D3);

    return MaterialApp(
      title: 'TuLog',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F6FC),
        colorScheme: ColorScheme.fromSeed(
          seedColor: lavender,
          primary: navy,
          secondary: lavender,
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF7F6FC),
          foregroundColor: navy,
          centerTitle: false,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: navy,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: lavender.withValues(alpha: 0.15),
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      home: const TuLogHome(),
    );
  }
}

class TuLogHome extends StatefulWidget {
  const TuLogHome({super.key});

  @override
  State<TuLogHome> createState() => _TuLogHomeState();
}

class _TuLogHomeState extends State<TuLogHome> {
  final SleepStorage _storage = SleepStorage();
  List<SleepRecord> _records = [];
  int _selectedIndex = 0;
  bool _isLoading = true;
  bool _isSaving = false;
  Object? _loadError;

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    setState(() {
      _isLoading = true;
      _loadError = null;
    });

    try {
      final records = await _storage.loadRecords();
      if (!mounted) return;
      setState(() {
        _records = records;
        _isLoading = false;
      });
    } on Exception catch (error) {
      if (!mounted) return;
      setState(() {
        _loadError = error;
        _isLoading = false;
      });
    }
  }

  Future<void> _saveRecord(SleepRecord record) async {
    setState(() => _isSaving = true);
    try {
      await _storage.saveRecord(record);
      if (!mounted) return;
      setState(() {
        _records = [
          record,
          ..._records.where((saved) => !saved.isSameDay(record.date)),
        ]..sort((a, b) => b.date.compareTo(a.date));
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your sleep record has been saved.')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_loadError != null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.cloud_off_outlined, size: 44),
                const SizedBox(height: 12),
                const Text(
                  'Could not load your sleep records.',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text('$_loadError', textAlign: TextAlign.center),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _loadRecords,
                  child: const Text('Try again'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final pages = [
      HomeScreen(
        records: _records,
        onOpenTracker: () => setState(() => _selectedIndex = 1),
        onOpenHistory: () => setState(() => _selectedIndex = 2),
      ),
      TrackerScreen(onSave: _saveRecord, isSaving: _isSaving),
      HistoryScreen(records: _records),
      const TipsScreen(),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('TuLog')),
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.nightlight_outlined),
            selectedIcon: Icon(Icons.nightlight_round),
            label: 'Tracker',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month_rounded),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_outlined),
            selectedIcon: Icon(Icons.auto_awesome),
            label: 'Tips',
          ),
        ],
      ),
    );
  }
}
