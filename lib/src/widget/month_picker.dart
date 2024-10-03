import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:provider/provider.dart';
import 'package:report/src/local/local.dart';
import 'package:report/src/model/report.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:report/src/notifier/repport_notifier.dart';
import '../notification/local_notification.dart';
import '../model/event.dart'; // Import the month_picker package

class MonthRangePickerScreen extends StatefulWidget {
  const MonthRangePickerScreen({super.key});

  @override
  State<MonthRangePickerScreen> createState() => _MonthRangePickerScreenState();
}

class _MonthRangePickerScreenState extends State<MonthRangePickerScreen> {
  DateTime? _selectedStartMonth; // For storing the selected start month
  DateTime? _selectedEndMonth;

  @override
  Widget build(BuildContext context) {
    final myNotifier = Provider.of<RepportNotifier>(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            AppLocalizations.of(context)!.firstMonth,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Show selected start month
            Text(
              _selectedStartMonth != null
                  ? DateFormat.yMMM()
                      .format(_selectedStartMonth!) // Format the month
                  : AppLocalizations.of(context)!
                      .chooseDate, //Dat mwen chwazi', // Default text if no selection
            ),
            monthPickerWidget(
              color: Colors.red,
              onPressed: () async {
                // Show the month picker for start month
                DateTime? picked = await showMonthYearPicker(
                  context: context,
                  initialDate: _selectedStartMonth ?? DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() {
                    _selectedStartMonth = picked;
                  });
                }
              },
              text: AppLocalizations.of(context)!.chooseMonth,
            ),
          ],
        ),
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            AppLocalizations.of(context)!.lastMonth,
          ), //Dènye mwa:
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Show selected end month
            Text(
              _selectedEndMonth != null
                  ? DateFormat.yMMM()
                      .format(_selectedEndMonth!) // Format the month
                  : AppLocalizations.of(context)!
                      .chooseDate, // Default text if no selection
            ),
            monthPickerWidget(
              color: Colors.blue,
              onPressed: () async {
                // Show the month picker for end month
                DateTime? picked = await showMonthYearPicker(
                  context: context,
                  initialDate: _selectedEndMonth ?? DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() {
                    _selectedEndMonth = picked;
                  });
                }
              },
              text: AppLocalizations.of(context)!
                  .chooseMonth, // 'Chwazi yon mwa',
            ),
          ],
        ),
        const SizedBox(height: 30),
        ElevatedButton(
            onPressed: () async {
              final event = Event(
                title: 'Monthly Report',
                comment: 'Time to submit your activity report!',
                pyonye: true,
              );

              // Handle the saving or processing logic for the selected months
              if (_selectedStartMonth != null && _selectedEndMonth != null) {
                // Perform the action with the selected months

                saveAndScheduleMonthRange(
                    event: event,
                    startMonth: _selectedStartMonth!,
                    endMonth: _selectedEndMonth!);

                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    content: Text(
                        '${AppLocalizations.of(context)!.serviceBegin} ${DateFormat.MMMM().format(_selectedStartMonth!)}')));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    content: Text(AppLocalizations.of(context)!.monthFilter)));
                // Handle cases where one or both months are not selected
              }
              myNotifier.refreshThisPage(true);
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: Text(
                AppLocalizations.of(context)!.addService) //'Ajoute Sèvis la'),
            ),
      ],
    );
  }

  Future<void> saveAndScheduleMonthRange({
    required Event event,
    required DateTime startMonth,
    required DateTime endMonth,
  }) async {
    DateTime currentMonth = startMonth;
    Map<List<DateTime>, Event> eventMap = {};

    // Iterate through each month in the range
    while (currentMonth.isBefore(endMonth) ||
        currentMonth.isAtSameMomentAs(endMonth)) {
      // Add the event for the current month to the event map
      eventMap[[DateTime(currentMonth.year, currentMonth.month)]] = event;

      // Schedule notification for the current month
      await ReportNification.scheduleLocalEventNotification(
        event: event,
        scheduledDate: DateTime(currentMonth.year, currentMonth.month, 1),
      );

      // Save report for the current month
      final report = Repport(
        name: '',
        isPyonye: true,
        student: 0,
        submitAt: DateTime(currentMonth.year, currentMonth.month, 1),
      );
      await SharedPreferencesSingleton().saveRepport(report);

      // Move to the next month, handling year transitions
      if (currentMonth.month == 12) {
        currentMonth = DateTime(currentMonth.year + 1, 1);
      } else {
        currentMonth = DateTime(currentMonth.year, currentMonth.month + 1);
      }
    }

    // Save all the events for the range using saveEventsWithDateRange
    await SharedPreferencesSingleton().saveEventsWithDateRange(eventMap);
  }

  Widget monthPickerWidget(
      {required VoidCallback onPressed, Color? color, required String text}) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).colorScheme.primary),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.calendar_month, color: color ?? Colors.black),
            const SizedBox(
              width: 12,
            ),
            Text(
              text,
              style:
                  TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
            )
          ],
        ),
      ),
    );
  }
}
