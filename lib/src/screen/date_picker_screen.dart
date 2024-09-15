import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../local/local.dart';
import '../model/repo.dart';

class DateRangePickerScreen extends StatefulWidget {
  const DateRangePickerScreen({super.key});
  static const routeName = '/datepicker_screen';
  @override
  // ignore: library_private_types_in_public_api
  _DateRangePickerScreenState createState() => _DateRangePickerScreenState();
}

class _DateRangePickerScreenState extends State<DateRangePickerScreen> {
  DateTimeRange? selectedDateRange;
  DateTime? selectedSingleDate;
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  bool isSingleDate = false; // Toggle between single date and date range
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  // Function to show DateRangePicker
  Future<void> _selectDateRange(BuildContext context) async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDateRange: selectedDateRange ??
          DateTimeRange(
            start: DateTime.now(),
            end: DateTime.now().add(const Duration(days: 1)),
          ),
    );

    if (picked != null && picked != selectedDateRange) {
      setState(() {
        selectedDateRange = picked;
        selectedSingleDate = null; // Clear single date if a range is selected
      });
    }
  }

  // Function to show DatePicker for a single date
  Future<void> _selectSingleDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedSingleDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != selectedSingleDate) {
      setState(() {
        selectedSingleDate = picked;
        selectedDateRange =
            null; // Clear date range if a single date is selected
      });
    }
  }

  // Function to add the repo to SharedPreferences
  Future<void> _addRepo() async {
    if ((selectedDateRange != null || selectedSingleDate != null) &&
        titleController.text.isNotEmpty &&
        contentController.text.isNotEmpty) {
      // Determine which dates to add (single date or date range)
      List<DateTime> dateRange = [];
      if (selectedSingleDate != null) {
        dateRange.add(selectedSingleDate!);
      } else if (selectedDateRange != null) {
        dateRange = [selectedDateRange!.start, selectedDateRange!.end];
      }

      // Create a new Repo object
      Repo newRepo = Repo(
        dates: dateRange,
        title: titleController.text,
        content: contentController.text,
      );

      // Add the Repo to SharedPreferences
      SharedPreferencesSingleton prefsSingleton = SharedPreferencesSingleton();
      await prefsSingleton.addRepo(newRepo);

      // Clear the input fields after adding
      titleController.clear();
      contentController.clear();
      setState(() {
        selectedDateRange = null;
        selectedSingleDate = null;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Bravo 👏!! sèvis pyonye a ap komanse ${dateRange.first}')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Byen konplete espas yo tanpri!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chwazi kilè w\'ap komanse ✍'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Tit'),
            ),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(labelText: 'Komant'),
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              title: const Text('Sèvis Pyonye pou yon mwa!'),
              value: isSingleDate,
              onChanged: (bool value) {
                setState(() {
                  isSingleDate = value;
                  selectedDateRange =
                      null; // Clear date range if switching to single date
                  selectedSingleDate = null;
                });
              },
            ),
            Row(
              children: <Widget>[
                Text(
                  isSingleDate
                      ? (selectedSingleDate == null
                          ? 'Ou Pa chwazi okenn Dat'
                          : 'Dat ou chwazi a : ${dateFormat.format(selectedSingleDate!)}')
                      : (selectedDateRange == null
                          ? 'Ou Pa chwazi okenn Dat'
                          : 'Komanse: ${dateFormat.format(selectedDateRange!.start)}\nPou fini: ${dateFormat.format(selectedDateRange!.end)}'),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () => isSingleDate
                      ? _selectSingleDate(context)
                      : _selectDateRange(context),
                  child: Text(
                      isSingleDate ? 'Chwazi yon mwa' : 'Chwazi plizyè mwa'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addRepo,
              child: const Text('Ajoute Sèvis la'),
            ),
          ],
        ),
      ),
    );
  }
}
