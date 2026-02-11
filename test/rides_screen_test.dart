import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:week_3_blabla_project/model/ride/locations.dart';
import 'package:week_3_blabla_project/model/ride_pref/ride_pref.dart';
import 'package:week_3_blabla_project/ui/screens/rides/rides_screen.dart';
import 'package:week_3_blabla_project/ui/screens/rides/widgets/ride_tile.dart';

void main() {
  group('RidesScreen Tests', () {
    testWidgets('should display screen title', (WidgetTester tester) async {
      final ridePref = RidePref(
        departure: Location.phnomPenh,
        arrival: Location.siemReap,
        departureDate: DateTime.now(),
        requestedSeats: 1,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: RidesScreen(ridePref: ridePref),
        ),
      );

      expect(find.text('Available Rides'), findsOneWidget);
    });

    testWidgets('should display search criteria summary',
        (WidgetTester tester) async {
      final ridePref = RidePref(
        departure: Location.phnomPenh,
        arrival: Location.siemReap,
        departureDate: DateTime.now(),
        requestedSeats: 2,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: RidesScreen(ridePref: ridePref),
        ),
      );

      expect(find.text('Phnom Penh'), findsOneWidget);
      expect(find.text('Siem Reap'), findsOneWidget);
      expect(find.text('2 seat(s) needed'), findsOneWidget);
    });

    testWidgets('should display results count', (WidgetTester tester) async {
      final ridePref = RidePref(
        departure: Location.phnomPenh,
        arrival: Location.siemReap,
        departureDate: DateTime.now(),
        requestedSeats: 1,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: RidesScreen(ridePref: ridePref),
        ),
      );

      // Wait for the state to update
      await tester.pump();

      // Should display count of filtered rides
      expect(find.textContaining('ride(s) found'), findsOneWidget);
    });

    testWidgets('should display RideTile widgets for filtered rides',
        (WidgetTester tester) async {
      final ridePref = RidePref(
        departure: Location.phnomPenh,
        arrival: Location.siemReap,
        departureDate: DateTime.now(),
        requestedSeats: 1,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: RidesScreen(ridePref: ridePref),
        ),
      );

      // Wait for the state to update
      await tester.pump();

      // Should display RideTile widgets
      expect(find.byType(RideTile), findsWidgets);
    });

    testWidgets('should display empty state when no rides found',
        (WidgetTester tester) async {
      // Create a ridePref that won't match any rides
      final ridePref = RidePref(
        departure: Location.phnomPenh,
        arrival: Location.siemReap,
        departureDate: DateTime.now(),
        requestedSeats: 100, // Unrealistic number to get no results
      );

      await tester.pumpWidget(
        MaterialApp(
          home: RidesScreen(ridePref: ridePref),
        ),
      );

      // Wait for the state to update
      await tester.pump();

      expect(find.text('No rides found'), findsOneWidget);
      expect(find.text('Try adjusting your search criteria'), findsOneWidget);
      expect(find.byIcon(Icons.search_off), findsOneWidget);
    });

    testWidgets('should display back button in app bar',
        (WidgetTester tester) async {
      final ridePref = RidePref(
        departure: Location.phnomPenh,
        arrival: Location.siemReap,
        departureDate: DateTime.now(),
        requestedSeats: 1,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: RidesScreen(ridePref: ridePref),
        ),
      );

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('should show snackbar when ride tile is tapped',
        (WidgetTester tester) async {
      final ridePref = RidePref(
        departure: Location.phnomPenh,
        arrival: Location.siemReap,
        departureDate: DateTime.now(),
        requestedSeats: 1,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: RidesScreen(ridePref: ridePref),
        ),
      );

      // Wait for the state to update
      await tester.pump();

      // Find and tap the first RideTile if it exists
      final rideTileFinder = find.byType(RideTile);
      if (tester.widgetList(rideTileFinder).isNotEmpty) {
        await tester.tap(rideTileFinder.first);
        await tester.pump();

        // Verify snackbar appears
        expect(find.byType(SnackBar), findsOneWidget);
      }
    });
  });
}
