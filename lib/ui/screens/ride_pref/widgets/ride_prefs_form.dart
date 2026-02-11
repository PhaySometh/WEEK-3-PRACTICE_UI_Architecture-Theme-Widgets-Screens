import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:week_3_blabla_project/ui/screens/location_picker/location_picker_screen.dart';
import 'package:week_3_blabla_project/ui/screens/ride_pref/widgets/bla_button.dart';
import 'package:week_3_blabla_project/ui/screens/ride_pref/widgets/form_tile.dart';
import 'package:week_3_blabla_project/ui/screens/rides/rides_screen.dart';
import 'package:week_3_blabla_project/ui/screens/seat_spinner/seat_spinner_screen.dart';
import 'package:week_3_blabla_project/ui/widgets/display/bla_divider.dart';
import 'package:week_3_blabla_project/ui/theme/theme.dart';
import 'package:week_3_blabla_project/utils/animations_util.dart';

import '../../../../model/ride/locations.dart';
import '../../../../model/ride_pref/ride_pref.dart';

///
/// A Ride Preference From is a view to select:
///   - A depcarture location
///   - An arrival location
///   - A date
///   - A number of seats
///
/// The form can be created with an existing RidePref (optional).
///
class RidePrefForm extends StatefulWidget {
  // The form can be created with an optional initial RidePref.
  final RidePref? initRidePref;
  final Function(RidePref)? onSearchPressed;

  const RidePrefForm({super.key, this.initRidePref, this.onSearchPressed});

  @override
  State<RidePrefForm> createState() => _RidePrefFormState();
}

class _RidePrefFormState extends State<RidePrefForm> {
  Location? departure;
  late DateTime departureDate;
  Location? arrival;
  late int requestedSeats;

  // ----------------------------------
  // Initialize the Form attributes
  // ----------------------------------

  @override
  void initState() {
    super.initState();
    departure = widget.initRidePref?.departure;
    arrival = widget.initRidePref?.arrival;
    departureDate = widget.initRidePref?.departureDate ?? DateTime.now();
    requestedSeats = widget.initRidePref?.requestedSeats ?? 1;
  }

  // ----------------------------------
  // Handle events
  // ----------------------------------

  // Consolidated location selection function
  Future<void> onSelectLocation(bool isDeparture) async {
    final selectedLocation = await Navigator.push(
      context,
      AnimationUtils.createBottomToTopRoute(LocationPickerScreen()),
    );
    if (selectedLocation != null) {
      setState(() {
        if (isDeparture) {
          departure = selectedLocation;
        } else {
          arrival = selectedLocation;
        }
      });
    }
  }

  void onSwitchLocations() {
    setState(() {
      final temp = departure;
      departure = arrival;
      arrival = temp;
    });
  }
Future<void> onSelectSeats() async {
    final selectedSeats = await Navigator.push(
      context,
      AnimationUtils.createBottomToTopRoute(
        SeatSpinnerScreen(initialSeats: requestedSeats),
      ),
    );
    if (selectedSeats != null) {
      setState(() {
        requestedSeats = selectedSeats;
      });
    }
  }

  
  void onSearchPressed() {
    if (isSearchValid) {
      final ridePref = RidePref(
        departure: departure!,
        arrival: arrival!,
        departureDate: departureDate,
        requestedSeats: requestedSeats,
      );

      // Navigate to RidesScreen with the ride preferences
      Navigator.push(
        context,
        AnimationUtils.createBottomToTopRoute(
          RidesScreen(ridePref: ridePref),
        ),
      );

      // Call the callback if provided
      if (widget.onSearchPressed != null) {
        widget.onSearchPressed!(ridePref);
      }
    }
  }

  // ----------------------------------
  // Compute the widgets rendering
  // ----------------------------------

  bool get isSearchValid => departure != null && arrival != null;

  String get dateText => DateFormat('EEEE, MMMM d').format(departureDate);
  String get seatsText => requestedSeats.toString();

  // ----------------------------------
  // Build the widgets
  // ----------------------------------
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(BlaSpacings.m),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Departure
          FormTile(
            customIcon: Icons.trip_origin,
            value: departure?.name,
            hintText: "Leaving from",
            onTap: () => onSelectLocation(true),
            trailing: departure != null
                ? IconButton(
                    icon: Icon(Icons.swap_vert, color: BlaColors.primary),
                    onPressed: onSwitchLocations,
                    iconSize: 20,
                  )
                : null,
          ),
          BlaDivider(),

          // Arrival
          FormTile(
            customIcon: Icons.location_on,
            value: arrival?.name,
            hintText: "Going to",
            onTap: () => onSelectLocation(false),
          ),
          BlaDivider(),

          // Date
          FormTile(
            customIcon: Icons.date_range,
            value: dateText,
            onTap: () {
              // TODO: Implement date picker
            },
          ),
          BlaDivider(),

          // Seats
          FormTile(
            customIcon: Icons.people,
            value: seatsText,
            onTap: onSelectSeats,
          ),

          SizedBox(height: BlaSpacings.m),

          // Search button - enabled only when departure and arrival are set
          BlaButton(
            customText: "Search",
            isPrimary: true,
            onPressed: isSearchValid ? onSearchPressed : null,
          ),
        ],
      ),
    );
  }
}
