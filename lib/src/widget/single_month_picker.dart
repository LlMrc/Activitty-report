import 'package:flutter/material.dart';

import '../feature/notification/local_notification.dart';
import '../model/event.dart';

class SingleMonthPicker extends StatefulWidget {
  const SingleMonthPicker({super.key});

  @override
  State<SingleMonthPicker> createState() => _SingleMonthPickerState();
}

class _SingleMonthPickerState extends State<SingleMonthPicker> {
    int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Year Dropdown
                  DropdownButton<int>(
                    value: selectedYear,
                    items: List.generate(101, (index) {
                      int year = 2020 + index;
                      return DropdownMenuItem(
                        value: year,
                        child: Text(year.toString()),
                      );
                    }),
                    onChanged: (value) {
                      setState(() {
                        if (value != null) selectedYear = value;
                      });
                    },
                  ),
                  // Month Dropdown
                  DropdownButton<int>(
                    value: selectedMonth,
                    items: List.generate(12, (index) {
                      int month = index + 1;
                      return DropdownMenuItem(
                        value: month,
                        child: Text(month.toString()),
                      );
                    }),
                    onChanged: (value) {
                      setState(() {
                        if (value != null) selectedMonth = value;
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
             _scheduleSingleMonthNotification(
              event: Event(
                title: 'Monthly Report',
                description: 'Time to submit your activity report!',
                pyonye: true,
              ),
              year: selectedYear,
              month: selectedMonth,
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



  // Function to schedule a notification for a single month
  Future<void> _scheduleSingleMonthNotification({
    required Event event,
    required int year,
    required int month,
  }) async {
    DateTime scheduledDate = DateTime(year, month, 1);

    await ReportNification.scheduleLocalEventNotification(
      event: event,
      scheduledDate: scheduledDate,
    );
  }
}