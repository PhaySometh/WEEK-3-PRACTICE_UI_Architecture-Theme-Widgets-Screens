import 'package:flutter/material.dart';
import '../../theme/theme.dart';

class SeatSpinnerScreen extends StatefulWidget {
  final int initialSeats;

  const SeatSpinnerScreen({
    super.key,
    this.initialSeats = 1,
  });

  @override
  State<SeatSpinnerScreen> createState() => _SeatSpinnerScreenState();
}

class _SeatSpinnerScreenState extends State<SeatSpinnerScreen> {
  late int selectedSeats;
  static const int minSeats = 1;
  static const int maxSeats = 8;

  @override
  void initState() {
    super.initState();
    selectedSeats = widget.initialSeats;
  }

  void _incrementSeats() {
    if (selectedSeats < maxSeats) {
      setState(() {
        selectedSeats++;
      });
    }
  }

  void _decrementSeats() {
    if (selectedSeats > minSeats) {
      setState(() {
        selectedSeats--;
      });
    }
  }

  void _confirmSelection() {
    Navigator.pop(context, selectedSeats);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(BlaSpacings.l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 40), // Spacer for alignment
                  IconButton(
                    icon: Icon(Icons.close, color: BlaColors.iconLight),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),

              const SizedBox(height: BlaSpacings.l),

              // Title
              Text(
                'Number of seats to book',
                style: BlaTextStyles.heading.copyWith(
                  fontSize: 20,
                  color: BlaColors.textNormal,
                ),
              ),

              const SizedBox(height: BlaSpacings.xl),

              // Spinner controls
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Decrement button
                  IconButton(
                    onPressed: selectedSeats > minSeats ? _decrementSeats : null,
                    icon: Icon(
                      Icons.remove_circle_outline,
                      size: 40,
                      color: selectedSeats > minSeats
                          ? BlaColors.iconLight
                          : BlaColors.greyLight,
                    ),
                  ),

                  const SizedBox(width: BlaSpacings.xl),

                  // Seat count display
                  SizedBox(
                    width: 60,
                    child: Text(
                      selectedSeats.toString(),
                      style: BlaTextStyles.heading.copyWith(
                        fontSize: 48,
                        color: BlaColors.textNormal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(width: BlaSpacings.xl),

                  // Increment button
                  IconButton(
                    onPressed: selectedSeats < maxSeats ? _incrementSeats : null,
                    icon: Icon(
                      Icons.add_circle_outline,
                      size: 40,
                      color: selectedSeats < maxSeats
                          ? BlaColors.primary
                          : BlaColors.greyLight,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Confirm button
              Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  onPressed: _confirmSelection,
                  backgroundColor: BlaColors.primary,
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
