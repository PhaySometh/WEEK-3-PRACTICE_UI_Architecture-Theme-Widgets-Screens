import 'package:flutter/material.dart';
import 'package:week_3_blabla_project/model/ride/locations.dart';
import 'package:week_3_blabla_project/services/location_service.dart';
import 'package:week_3_blabla_project/services/location_history_service.dart';
import 'package:week_3_blabla_project/ui/screens/location_picker/location_picker_tile.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filter locations based on search query
  List<Location> get filteredLocations {
    if (_searchQuery.isEmpty) {
      return []; // Show nothing when no search query
    }
    return LocationsService.availableLocations
        .where((location) =>
            location.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            location.country.name
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()))
        .toList();
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
    });
  }

  void _onLocationSelected(Location location) {
    // Add to shared history
    LocationHistoryService.addToHistory(location);
    Navigator.pop(context, location);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Search bar
            ListTile(
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () => Navigator.pop(context),
              ),
              title: TextFormField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search location...',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
              trailing: IconButton(
                onPressed: _searchQuery.isNotEmpty ? _clearSearch : null,
                icon: Icon(Icons.close),
              ),
            ),
            Divider(height: 1),

            // History section (show when no search query)
            if (_searchQuery.isEmpty &&
                LocationHistoryService.history.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: LocationHistoryService.history.length,
                  itemBuilder: (context, index) {
                    final Location location =
                        LocationHistoryService.history[index];
                    return LocationPickerTile(
                      location: location,
                      showHistoryIcon: true,
                      onTap: () => _onLocationSelected(location),
                    );
                  },
                ),
              ),

            // Search results (show when typing)
            if (_searchQuery.isNotEmpty)
              Expanded(
                child: filteredLocations.isEmpty
                    ? Center(
                        child: Text(
                          'No locations found',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredLocations.length,
                        itemBuilder: (context, index) {
                          final Location location = filteredLocations[index];
                          return LocationPickerTile(
                            location: location,
                            showHistoryIcon:
                                LocationHistoryService.isInHistory(location),
                            onTap: () => _onLocationSelected(location),
                          );
                        },
                      ),
              ),

            // Empty state when no search and no history
            if (_searchQuery.isEmpty && LocationHistoryService.history.isEmpty)
              Expanded(
                child: Center(
                  child: Text(
                    'Start typing to search locations',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
