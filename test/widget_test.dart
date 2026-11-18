import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tulog/main.dart';
import 'package:tulog/models/sleep_record.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('calculates sleep duration across midnight', () {
    expect(
      SleepRecord.calculateDurationMinutes(22 * 60 + 30, 6 * 60 + 30),
      8 * 60,
    );
  });

  testWidgets('shows dashboard and navigates to tracker', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const TuLogApp());
    await tester.pumpAndSettle();

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Not logged yet'), findsOneWidget);

    await tester.tap(find.text('Tracker'));
    await tester.pumpAndSettle();
    expect(find.text('Track your sleep'), findsOneWidget);
    expect(find.text('8h 0m'), findsOneWidget);
  });

  testWidgets('saves a sleep record and shows it in history', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const TuLogApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Tracker'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save sleep record'));
    await tester.pumpAndSettle();

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await tester.pumpWidget(const TuLogApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('History'));
    await tester.pumpAndSettle();

    expect(find.text(formatDuration(8 * 60)), findsOneWidget);
    expect(find.text('10:30 PM'), findsOneWidget);
    expect(find.text('6:30 AM'), findsOneWidget);
  });
}
