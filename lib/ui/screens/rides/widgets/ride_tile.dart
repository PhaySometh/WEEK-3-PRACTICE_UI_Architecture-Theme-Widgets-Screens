import 'package:flutter/material.dart';
import '../../../../model/ride/ride.dart';
import '../../../../utils/date_time_utils.dart';
import '../../../theme/theme.dart';

class RideTile extends StatelessWidget {
  final Ride ride;
  final VoidCallback? onTap;

  const RideTile({
    super.key,
    required this.ride,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: BlaSpacings.m,
          vertical: BlaSpacings.s / 2,
        ),
        padding: const EdgeInsets.all(BlaSpacings.m),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(BlaSpacings.radius),
          border: Border.all(
            color: BlaColors.greyLight,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Departure and Arrival
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ride.departureLocation.name,
                        style: BlaTextStyles.body.copyWith(
                          fontWeight: FontWeight.bold,
                          color: BlaColors.textNormal,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateTimeUtils.formatDateTime(ride.departureDate),
                        style: BlaTextStyles.label.copyWith(
                          color: BlaColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward,
                  color: BlaColors.iconLight,
                  size: 20,
                ),
                const SizedBox(width: BlaSpacings.s),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ride.arrivalLocation.name,
                        style: BlaTextStyles.body.copyWith(
                          fontWeight: FontWeight.bold,
                          color: BlaColors.textNormal,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateTimeUtils.formatDateTime(ride.arrivalDateTime),
                        style: BlaTextStyles.label.copyWith(
                          color: BlaColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: BlaSpacings.m),
            // Driver and Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: BlaColors.primary.withOpacity(0.2),
                      child: Text(
                        ride.driver.firstName[0].toUpperCase(),
                        style: BlaTextStyles.label.copyWith(
                          color: BlaColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: BlaSpacings.s / 2),
                    Text(
                      ride.driver.firstName,
                      style: BlaTextStyles.label.copyWith(
                        color: BlaColors.textNormal,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.event_seat,
                      size: 16,
                      color: BlaColors.iconLight,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${ride.remainingSeats} left',
                      style: BlaTextStyles.label.copyWith(
                        color: BlaColors.textLight,
                      ),
                    ),
                    const SizedBox(width: BlaSpacings.m),
                    Text(
                      '\$${ride.pricePerSeat.toStringAsFixed(2)}',
                      style: BlaTextStyles.body.copyWith(
                        fontWeight: FontWeight.bold,
                        color: BlaColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
