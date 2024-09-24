import 'package:flutter/material.dart';

import '../feature/notification/local_notification.dart';
import '../model/event.dart';

class MonthRangePicker extends StatefulWidget {
  const MonthRangePicker({super.key});

  @override
  State<MonthRangePicker> createState() => _MonthRangePickerState();
}

class _MonthRangePickerState extends State<MonthRangePicker> {
  int selectedStartYear = DateTime.now().year;
  int selectedStartMonth = DateTime.now().month;
  int selectedEndYear = DateTime.now().year;
  int selectedEndMonth = DateTime.now().month;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Premye mwa'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Start Year Dropdown
            DropdownButton<int>(
              value: selectedStartYear,
              items: List.generate(101, (index) {
                int year = 2020 + index;
                return DropdownMenuItem(
                  value: year,
                  child: Text(year.toString()),
                );
              }),
              onChanged: (value) {
                setState(() {
                  if (value != null) selectedStartYear = value;
                });
              },
            ),
            // Start Month Dropdown
            DropdownButton<int>(
              value: selectedStartMonth,
              items: List.generate(12, (index) {
                int month = index + 1;
                return DropdownMenuItem(
                  value: month,
                  child: Text(month.toString()),
                );
              }),
              onChanged: (value) {
                setState(() {
                  if (value != null) selectedStartMonth = value;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text('Dènye mwa:'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // End Year Dropdown
            DropdownButton<int>(
              value: selectedEndYear,
              items: List.generate(101, (index) {
                int year = 2020 + index;
                return DropdownMenuItem(
                  value: year,
                  child: Text(year.toString()),
                );
              }),
              onChanged: (value) {
                setState(() {
                  if (value != null) selectedEndYear = value;
                });
              },
            ),
            // End Month Dropdown
            DropdownButton<int>(
              value: selectedEndMonth,
              items: List.generate(12, (index) {
                int month = index + 1;
                return DropdownMenuItem(
                  value: month,
                  child: Text(month.toString()),
                );
              }),
              onChanged: (value) {
                setState(() {
                  if (value != null) selectedEndMonth = value;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary),
          onPressed: () {
            // Call the scheduling method here with the selected months
            scheduleNotificationsForMonthRange(
              event: Event(
                title: 'Monthly Report',
                description: 'Time to submit your activity report!',
                timeStamp: null,
                pyonye: true,
              ),
              startYear: selectedStartYear,
              startMonth: selectedStartMonth,
              endYear: selectedEndYear,
              endMonth: selectedEndMonth,
            );
          },
          child: Text(
            'Ajoute Sèvis la',
            style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
          ),
        ),
      ],
    );
  }

  Future<void> scheduleNotificationsForMonthRange({
    required Event event,
    required int startYear,
    required int startMonth,
    required int endYear,
    required int endMonth,
  }) async {
    DateTime currentMonth = DateTime(startYear, startMonth);
    DateTime lastMonth = DateTime(endYear, endMonth);

    while (currentMonth.isBefore(lastMonth) ||
        currentMonth.isAtSameMomentAs(lastMonth)) {
      // Schedule notification for the first day of the current month
      DateTime scheduledDate = DateTime(
        currentMonth.year,
        currentMonth.month,
        1,
      );

      // Call your notification scheduling method
      await ReportNification.scheduleLocalEventNotification(
        event: event,
        scheduledDate: scheduledDate,
      );

      // Move to the next month
      currentMonth = DateTime(currentMonth.year, currentMonth.month + 1);
    }
  }
}
