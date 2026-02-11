import '../data/dummy_data.dart';
import '../model/ride/locations.dart';
import '../model/ride/ride.dart';

////
///   This service handles:
///   - The list of available rides
///
class RidesService {
  static List<Ride> allRides = fakeRides; // TODO for now fake data

  static List<Ride> filterByDeparture(Location departure) {
    return allRides
        .where((ride) => ride.departureLocation == (departure))
        .toList();
  }

  static List<Ride> filterBySeatRequested(int seatRequested) {
    return allRides
        .where((ride) => ride.remainingSeats >= seatRequested)
        .toList();
  }

  static List<Ride> filterBy({Location? departure, int? seatRequested}) {
    return allRides.where((ride) {
      if (departure != null && ride.departureLocation != departure) {
        return false;
      }

      if (seatRequested != null && ride.remainingSeats < seatRequested) {
        return false;
      }

      return true;
    }).toList();
  }
}
