import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:provider/provider.dart';
import 'package:report/src/local/local.dart';
import 'package:report/src/notifier/repport_notifier.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../notification/local_notification.dart';
import '../model/event.dart';

class SingleMonthPicker extends StatefulWidget {
  const SingleMonthPicker({super.key});

  @override
  State<SingleMonthPicker> createState() => _SingleMonthPickerState();
}

class _SingleMonthPickerState extends State<SingleMonthPicker> {
  DateTime? _selectedMonth;

  @override
  Widget build(BuildContext context) {
    final myNotifier = Provider.of<RepportNotifier>(context);
    return Column(
      children: [
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Year Dropdown
            Text(
              _selectedMonth != null
                  ? DateFormat.yMMM()
                      .format(_selectedMonth!) // Format the month
                  : AppLocalizations.of(context)!
                      .chooseDate, // Default text if no selection
            ),
            // Month Dropdown
            monthPickerWidget(
              onPressed: () async {
                // Show the month picker for end month
                DateTime? picked = await showMonthYearPicker(
                  context: context,
                  initialDate: _selectedMonth ?? DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() {
                    _selectedMonth = picked;
                  });
                }
              },
              text: AppLocalizations.of(context)!.chooseMonth,
            ),
          ],
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary),
          onPressed: () async {
            await myNotifier
                .repportPyonyeNotifier(); // Schedule the notification for the selected month
            _scheduleSingleMonthNotification(
              event: Event(
                title: 'Monthly Report',
                comment: 'Time to submit your activity report!',
                pyonye: true,
              ),
              scheduledDate: _selectedMonth ?? DateTime.now(),
            );
            myNotifier.refreshThisPage(true);
            if (context.mounted) {
              Navigator.pop(context);
            }
          },
          child: Text(
            AppLocalizations.of(context)!.addService, //  'Ajoute Sèvis la',
            style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
          ),
        ),
      ],
    );
  }

  // Function to schedule a notification for a single month
  Future<void> _scheduleSingleMonthNotification({
    required Event event,
    required DateTime scheduledDate,
  }) async {
    await ReportNofication.scheduleLocalEventNotification(
      event: event,
      scheduledDate: scheduledDate,
    );
    // Create the key using only year and month
    DateTime monthKey = DateTime(scheduledDate.year, scheduledDate.month, 1);
    // Create a new map and add the event to the list for the corresponding month
    Map<DateTime, List<Event>> events = {
      monthKey: [event],
    };
    await SharedPreferencesSingleton().saveEvents(events);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          content: Text(
              '${AppLocalizations.of(context)!.serviceBegin} ${DateFormat.MMMM().format(_selectedMonth!)}')));
    }
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
