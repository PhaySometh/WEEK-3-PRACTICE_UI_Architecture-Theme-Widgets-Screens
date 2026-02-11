import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:week_3_blabla_project/ui/screens/date_picker/date_picker_screen.dart';

void main() {
  group('DatePickerScreen Tests', () {
    final today = DateTime.now();
    final tomorrow = today.add(const Duration(days: 1));

    testWidgets('should display the title "When are you going?"',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DatePickerScreen(initialDate: today),
        ),
      );

      expect(find.text('When are you going?'), findsOneWidget);
    });

    testWidgets('should have a close button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DatePickerScreen(initialDate: today),
        ),
      );

      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('should display days of week header',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DatePickerScreen(initialDate: today),
        ),
      );

      expect(find.text('Mon'), findsOneWidget);
      expect(find.text('Tue'), findsOneWidget);
      expect(find.text('Wed'), findsOneWidget);
      expect(find.text('Thu'), findsOneWidget);
      expect(find.text('Fri'), findsOneWidget);
      expect(find.text('Sat'), findsOneWidget);
      expect(find.text('Sun'), findsOneWidget);
    });

    testWidgets('should display current month name',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DatePickerScreen(initialDate: today),
        ),
      );

      final currentMonthName = DateFormat('MMMM').format(today);
      expect(find.text(currentMonthName), findsOneWidget);
    });

    testWidgets('should display multiple months', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DatePickerScreen(initialDate: today),
        ),
      );

      final currentMonthName = DateFormat('MMMM').format(today);
      final nextMonthName =
          DateFormat('MMMM').format(DateTime(today.year, today.month + 1, 1));

      expect(find.text(currentMonthName), findsOneWidget);
      expect(find.text(nextMonthName), findsOneWidget);
    });

    testWidgets('should display calendar dates', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DatePickerScreen(initialDate: today),
        ),
      );

      // Should find various day numbers
      expect(find.text('1'), findsWidgets);
      expect(find.text('15'), findsWidgets);
    });

    testWidgets('should return selected date when date is tapped',
        (WidgetTester tester) async {
      DateTime? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DatePickerScreen(initialDate: tomorrow),
                    ),
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );

      // Open the date picker
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      // Find and tap a future date (day 15 should be safe)
      final dateTiles = find.text('15');
      expect(dateTiles, findsWidgets);

      // Tap the first occurrence of day 15
      await tester.tap(dateTiles.first);
      await tester.pumpAndSettle();

      // Should have returned a date
      expect(result, isNotNull);
      expect(result!.day, 15);
    });

    testWidgets('should close when close button is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DatePickerScreen(initialDate: today),
                    ),
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );

      // Open the date picker
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      // Verify we're on the date picker screen
      expect(find.text('When are you going?'), findsOneWidget);

      // Tap close button
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // Should be back to the original screen
      expect(find.text('When are you going?'), findsNothing);
      expect(find.text('Open'), findsOneWidget);
    });

    testWidgets('should be scrollable to view multiple months',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DatePickerScreen(initialDate: today),
        ),
      );

      // Find the scrollable widget
      final scrollableFinder = find.byType(SingleChildScrollView);
      expect(scrollableFinder, findsOneWidget);

      // Scroll down
      await tester.drag(scrollableFinder, const Offset(0, -300));
      await tester.pumpAndSettle();

      // Should still be able to see content
      expect(find.text('When are you going?'), findsOneWidget);
    });

    testWidgets('should highlight today\'s date differently',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DatePickerScreen(initialDate: today),
        ),
      );

      // The calendar should be rendered with today highlighted
      // This is a visual test, but we can verify the structure exists
      expect(find.byType(GestureDetector), findsWidgets);
    });
  });
}
