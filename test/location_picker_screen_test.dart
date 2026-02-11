import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:week_3_blabla_project/model/ride/locations.dart';
import 'package:week_3_blabla_project/ui/screens/location_picker/location_picker_screen.dart';

void main() {
  group('LocationPickerScreen Tests', () {
    // Test 1: Initial state shows empty message
    testWidgets('Shows empty state when no search and no history',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LocationPickerScreen(),
        ),
      );

      // Verify empty state message
      expect(find.text('Start typing to search locations'), findsOneWidget);
      expect(find.byType(ListView), findsNothing);
    });

    // Test 2: Search bar exists
    testWidgets('Search bar is visible', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LocationPickerScreen(),
        ),
      );

      // Verify search bar elements
      expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
      expect(find.text('Search location...'), findsOneWidget);
    });

    // Test 3: Back button works
    testWidgets('Back button pops the screen', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => LocationPickerScreen()),
                ),
                child: Text('Open Picker'),
              ),
            ),
          ),
        ),
      );

      // Open location picker
      await tester.tap(find.text('Open Picker'));
      await tester.pumpAndSettle();

      // Verify picker is shown
      expect(find.byType(LocationPickerScreen), findsOneWidget);

      // Tap back button
      await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
      await tester.pumpAndSettle();

      // Verify picker is closed
      expect(find.byType(LocationPickerScreen), findsNothing);
    });

    // Test 4: Search filtering works
    testWidgets('Search filters locations', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LocationPickerScreen(),
        ),
      );

      // Type in search bar
      await tester.enterText(find.byType(TextFormField), 'Paris');
      await tester.pump();

      // Verify filtered results are shown
      expect(find.text('Paris'), findsWidgets);
      expect(find.byType(ListView), findsOneWidget);
    });

    // Test 5: Clear button works
    testWidgets('Clear button clears search', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LocationPickerScreen(),
        ),
      );

      // Type in search bar
      await tester.enterText(find.byType(TextFormField), 'Paris');
      await tester.pump();

      // Verify text is entered
      expect(find.text('Paris'), findsWidgets);

      // Tap clear button
      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();

      // Verify search is cleared
      final textField =
          tester.widget<TextFormField>(find.byType(TextFormField));
      expect(textField.controller?.text, isEmpty);
    });

    // Test 6: Clear button is disabled when search is empty
    testWidgets('Clear button disabled when no search text',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LocationPickerScreen(),
        ),
      );

      // Find clear button
      final clearButton = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.close),
      );

      // Verify button is disabled
      expect(clearButton.onPressed, isNull);
    });

    // Test 7: Location selection returns location
    testWidgets('Selecting location returns it', (WidgetTester tester) async {
      Location? selectedLocation;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  selectedLocation = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => LocationPickerScreen()),
                  );
                },
                child: Text('Open Picker'),
              ),
            ),
          ),
        ),
      );

      // Open location picker
      await tester.tap(find.text('Open Picker'));
      await tester.pumpAndSettle();

      // Search for a location
      await tester.enterText(find.byType(TextFormField), 'Paris');
      await tester.pump();

      // Tap first location
      await tester.tap(find.byType(ListTile).first);
      await tester.pumpAndSettle();

      // Verify location was returned
      expect(selectedLocation, isNotNull);
      expect(selectedLocation?.name, contains('Paris'));
    });

    // Test 8: No results message shown
    testWidgets('Shows no results message for invalid search',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LocationPickerScreen(),
        ),
      );

      // Type invalid search
      await tester.enterText(find.byType(TextFormField), 'xyz123invalid');
      await tester.pump();

      // Verify no results message
      expect(find.text('No locations found'), findsOneWidget);
    });
  });
}
