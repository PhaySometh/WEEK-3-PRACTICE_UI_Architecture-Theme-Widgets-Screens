import '../model/ride/locations.dart';

///
/// This service handles location selection history
/// Shared between departure and arrival selections
///
class LocationHistoryService {
  static final List<Location> _history = [];

  /// Get the location history
  static List<Location> get history => List.unmodifiable(_history);

  /// Add a location to history (at the beginning)
  static void addToHistory(Location location) {
    // Remove if already exists (move to top)
    _history.removeWhere((loc) => loc.name == location.name);

    // Add to beginning
    _history.insert(0, location);

    // Keep only last 10 locations
    if (_history.length > 10) {
      _history.removeRange(10, _history.length);
    }
  }

  /// Check if a location is in history
  static bool isInHistory(Location location) {
    return _history.any((loc) => loc.name == location.name);
  }

  /// Clear all history (for testing)
  static void clearHistory() {
    _history.clear();
  }
}
