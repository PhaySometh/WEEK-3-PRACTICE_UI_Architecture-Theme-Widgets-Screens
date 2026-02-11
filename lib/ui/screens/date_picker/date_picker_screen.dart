import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../theme/theme.dart';

class DatePickerScreen extends StatefulWidget {
  final DateTime initialDate;

  const DatePickerScreen({
    super.key,
    required this.initialDate,
  });

  @override
  State<DatePickerScreen> createState() => _DatePickerScreenState();
}

class _DatePickerScreenState extends State<DatePickerScreen> {
  late DateTime selectedDate;
  late DateTime displayedMonth;
  final DateTime today = DateTime.now();
  final int monthsToShow = 12; // Show 12 months for better usability

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
    displayedMonth = DateTime(selectedDate.year, selectedDate.month, 1);
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  bool isBeforeToday(DateTime date) {
    final todayStart = DateTime(today.year, today.month, today.day);
    final dateStart = DateTime(date.year, date.month, date.day);
    return dateStart.isBefore(todayStart);
  }

  void _onDateSelected(DateTime date) {
    if (!isBeforeToday(date)) {
      setState(() {
        selectedDate = date;
      });
      // Auto-close after selection
      Navigator.pop(context, selectedDate);
    }
  }

  Widget _buildDayOfWeekHeader() {
    final daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: daysOfWeek.map((day) {
        return Expanded(
          child: Center(
            child: Text(
              day,
              style: BlaTextStyles.label.copyWith(
                fontSize: 12,
                color: BlaColors.textLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalendarMonth(DateTime month) {
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final lastDayOfMonth = DateTime(month.year, month.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;

    // Get the weekday of the first day (1 = Monday, 7 = Sunday)
    int firstWeekday = firstDayOfMonth.weekday;

    // Calculate total cells needed
    final totalCells = firstWeekday - 1 + daysInMonth;
    final totalRows = (totalCells / 7).ceil();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Month name
        Padding(
          padding: const EdgeInsets.symmetric(vertical: BlaSpacings.m),
          child: Text(
            DateFormat('MMMM').format(month),
            style: BlaTextStyles.heading.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: BlaColors.textNormal,
            ),
          ),
        ),

        // Calendar grid
        ...List.generate(totalRows, (rowIndex) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (colIndex) {
              final cellIndex = rowIndex * 7 + colIndex;
              final dayNumber = cellIndex - (firstWeekday - 1) + 1;

              if (cellIndex < firstWeekday - 1 || dayNumber > daysInMonth) {
                // Empty cell
                return Expanded(
                  child: Container(
                    height: 40,
                    margin: const EdgeInsets.all(2),
                  ),
                );
              }

              final date = DateTime(month.year, month.month, dayNumber);
              final isSelected = isSameDay(date, selectedDate);
              final isToday = isSameDay(date, today);
              final isPast = isBeforeToday(date);

              return Expanded(
                child: GestureDetector(
                  onTap: () => _onDateSelected(date),
                  child: Container(
                    height: 40,
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color:
                          isSelected ? BlaColors.primary : Colors.transparent,
                      shape: BoxShape.circle,
                      border: isToday && !isSelected
                          ? Border.all(color: BlaColors.primary, width: 1)
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        dayNumber.toString(),
                        style: BlaTextStyles.label.copyWith(
                          color: isSelected
                              ? Colors.white
                              : isPast
                                  ? BlaColors.greyLight
                                  : BlaColors.textNormal,
                          fontWeight: isToday || isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with close button
            Padding(
              padding: const EdgeInsets.all(BlaSpacings.m),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 40), // Spacer
                  Text(
                    'When are you going?',
                    style: BlaTextStyles.heading.copyWith(
                      fontSize: 18,
                      color: BlaColors.textNormal,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: BlaColors.iconLight),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Day of week header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: BlaSpacings.m),
              child: _buildDayOfWeekHeader(),
            ),

            const SizedBox(height: BlaSpacings.s),

            // Scrollable calendar months
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: BlaSpacings.m),
                child: Column(
                  children: List.generate(monthsToShow, (index) {
                    final month = DateTime(
                      displayedMonth.year,
                      displayedMonth.month + index,
                      1,
                    );
                    return _buildCalendarMonth(month);
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
