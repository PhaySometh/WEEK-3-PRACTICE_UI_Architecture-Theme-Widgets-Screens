import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:week_3_blabla_project/ui/screens/seat_spinner/seat_spinner_screen.dart';

void main() {
  group('SeatSpinnerScreen Tests', () {
    testWidgets('should display the title "Number of seats to book"',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SeatSpinnerScreen(),
        ),
      );

      expect(find.text('Number of seats to book'), findsOneWidget);
    });

    testWidgets('should display initial seat count', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SeatSpinnerScreen(initialSeats: 3),
        ),
      );

      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('should increment seat count when plus button is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SeatSpinnerScreen(initialSeats: 2),
        ),
      );

      // Find the increment button (add icon)
      final incrementButton = find.byIcon(Icons.add_circle_outline);
      expect(incrementButton, findsOneWidget);

      // Tap the increment button
      await tester.tap(incrementButton);
      await tester.pump();

      // Should now show 3
      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('should decrement seat count when minus button is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SeatSpinnerScreen(initialSeats: 3),
        ),
      );

      // Find the decrement button (remove icon)
      final decrementButton = find.byIcon(Icons.remove_circle_outline);
      expect(decrementButton, findsOneWidget);

      // Tap the decrement button
      await tester.tap(decrementButton);
      await tester.pump();

      // Should now show 2
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('should not decrement below 1', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SeatSpinnerScreen(initialSeats: 1),
        ),
      );

      // Verify it shows 1
      expect(find.text('1'), findsOneWidget);

      // Find the decrement button
      final decrementButton = find.byIcon(Icons.remove_circle_outline);
      
      // Try to tap it (should be disabled)
      await tester.tap(decrementButton);
      await tester.pump();

      // Should still show 1
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('should not increment above 8', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SeatSpinnerScreen(initialSeats: 8),
        ),
      );

      // Verify it shows 8
      expect(find.text('8'), findsOneWidget);

      // Find the increment button
      final incrementButton = find.byIcon(Icons.add_circle_outline);
      
      // Try to tap it (should be disabled)
      await tester.tap(incrementButton);
      await tester.pump();

      // Should still show 8
      expect(find.text('8'), findsOneWidget);
    });

    testWidgets('should have a close button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SeatSpinnerScreen(),
        ),
      );

      // Should find the close icon
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('should have a confirm button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SeatSpinnerScreen(),
        ),
      );

      // Should find the check icon in FAB
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('should return selected seats when confirm button is tapped',
        (WidgetTester tester) async {
      int? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SeatSpinnerScreen(initialSeats: 3),
                    ),
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );

      // Open the seat spinner
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      // Tap confirm button (FAB with check icon)
      await tester.tap(find.byIcon(Icons.check));
      await tester.pumpAndSettle();

      // Should have returned 3
      expect(result, 3);
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
                      builder: (context) => const SeatSpinnerScreen(),
                    ),
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );

      // Open the seat spinner
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      // Verify we're on the seat spinner screen
      expect(find.text('Number of seats to book'), findsOneWidget);

      // Tap close button
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // Should be back to the original screen
      expect(find.text('Number of seats to book'), findsNothing);
      expect(find.text('Open'), findsOneWidget);
    });
  });
}
