import 'package:flutter_test/flutter_test.dart';
import 'package:week_3_blabla_project/model/ride/locations.dart';
import 'package:week_3_blabla_project/services/rides_service.dart';

void main() {
  test('test the filter method', () {
    final result = RidesService.filterBy(
      departure: Location(name: "Dijon", country: Country.france),
      seatRequested: 2,
    ); // Shall return 1 ride

    expect(result.length, 1);
  });
}
