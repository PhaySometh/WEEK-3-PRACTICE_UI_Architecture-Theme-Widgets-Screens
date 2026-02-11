import 'package:flutter/material.dart';
import '../../../model/ride/ride.dart';
import '../../../model/ride_pref/ride_pref.dart';
import '../../../services/rides_service.dart';
import '../../theme/theme.dart';
import 'widgets/ride_tile.dart';

class RidesScreen extends StatefulWidget {
  final RidePref ridePref;

  const RidesScreen({
    super.key,
    required this.ridePref,
  });

  @override
  State<RidesScreen> createState() => _RidesScreenState();
}

class _RidesScreenState extends State<RidesScreen> {
  List<Ride> filteredRides = [];

  @override
  void initState() {
    super.initState();
    _loadRides();
  }

  void _loadRides() {
    setState(() {
      filteredRides = RidesService.filterBy(
        departure: widget.ridePref.departure,
        arrival: widget.ridePref.arrival,
        seatRequested: widget.ridePref.requestedSeats,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BlaColors.backgroundAccent,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: BlaColors.iconNormal),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Available Rides',
          style: BlaTextStyles.heading.copyWith(
            fontSize: 20,
            color: BlaColors.textNormal,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: BlaColors.greyLight,
            height: 1,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search criteria summary
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(BlaSpacings.m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: BlaColors.iconLight,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.ridePref.departure?.name ?? 'Any',
                      style: BlaTextStyles.label.copyWith(
                        color: BlaColors.textNormal,
                      ),
                    ),
                    const SizedBox(width: BlaSpacings.s),
                    Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: BlaColors.iconLight,
                    ),
                    const SizedBox(width: BlaSpacings.s),
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: BlaColors.iconLight,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.ridePref.arrival?.name ?? 'Any',
                      style: BlaTextStyles.label.copyWith(
                        color: BlaColors.textNormal,
                      ),
                    ),
                  ],
                ),
                if (widget.ridePref.requestedSeats != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.event_seat,
                        size: 16,
                        color: BlaColors.iconLight,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${widget.ridePref.requestedSeats} seat(s) needed',
                        style: BlaTextStyles.label.copyWith(
                          color: BlaColors.textNormal,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: BlaSpacings.s),
          // Results count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: BlaSpacings.m),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${filteredRides.length} ride(s) found',
                style: BlaTextStyles.label.copyWith(
                  color: BlaColors.textLight,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: BlaSpacings.s),
          // Rides list
          Expanded(
            child: filteredRides.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: BlaColors.iconLight,
                        ),
                        const SizedBox(height: BlaSpacings.m),
                        Text(
                          'No rides found',
                          style: BlaTextStyles.body.copyWith(
                            color: BlaColors.textLight,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try adjusting your search criteria',
                          style: BlaTextStyles.label.copyWith(
                            color: BlaColors.textLight,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(
                      bottom: BlaSpacings.m,
                      top: BlaSpacings.s / 2,
                    ),
                    itemCount: filteredRides.length,
                    itemBuilder: (context, index) {
                      final ride = filteredRides[index];
                      return RideTile(
                        ride: ride,
                        onTap: () {
                          // TODO: Navigate to ride details screen
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Ride from ${ride.departureLocation.name} to ${ride.arrivalLocation.name}',
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
