import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting the Date and Time
import 'package:provider/provider.dart';
import 'package:report/src/notifier/my_notifier.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../model/student.dart'; // Import your Student model

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});
  static const routeName = '/student';
  @override
  _AddStudentScreenState createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  DateTime _selectedDateTime = DateTime.now(); // Store both date and time

  // Method to pick date
  Future<void> _pickDate(BuildContext context) async {
    // Unfocus any text fields or input elements to dismiss the keyboard
    FocusScope.of(context).unfocus();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      // Update only the date part, keep the time part intact
      final updatedDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        _selectedDateTime.hour,
        _selectedDateTime.minute,
      );
      setState(() {
        _selectedDateTime = updatedDateTime;
      });

      // After picking the date, call the _pickTime function
      if (context.mounted) {
        await _pickTime(context);
      }
    }
  }

  // Method to pick time
  Future<void> _pickTime(BuildContext context) async {
    // Unfocus any text fields or input elements to dismiss the keyboard
    FocusScope.of(context).unfocus();
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
    );

    if (pickedTime != null) {
      // Update only the time part, keep the date part intact
      final updatedDateTime = DateTime(
        _selectedDateTime.year,
        _selectedDateTime.month,
        _selectedDateTime.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      setState(() {
        _selectedDateTime = updatedDateTime;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<PyonyeNotifier>(context);

    return GestureDetector(
      onTap: () {
        // Dismiss the keyboard when tapping outside of the Form
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(AppLocalizations.of(context)!.addStudent.toUpperCase()),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 50),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: _phoneNumberController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value != null && value.isNotEmpty && value.length < 7) {
                      return AppLocalizations.of(context)!.validNumber;
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  maxLines: 3,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Comment'),
                  controller: _commentController,
                ),
                const SizedBox(height: 20),
                ListTile(
                  title: Text(
                    '${DateFormat.EEEE().format(_selectedDateTime)} '
                    '${DateFormat.Hm().format(_selectedDateTime)}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _pickDate(context),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                          Theme.of(context).colorScheme.secondaryContainer)),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Create a new Student object
                      final student = Student(
                        name: _nameController.text,
                        phoneNumber: _phoneNumberController.text,
                        dateAdded: _selectedDateTime,
                        comment: _commentController.text,
                        address: _addressController.text,
                      );
                      await notifier.addStudent(student);
                      // Clear the form
                      _nameController.clear();
                      _phoneNumberController.clear();
                      _addressController.clear();
                      _commentController.clear();
                      setState(() {
                        _selectedDateTime = DateTime.now();
                      });
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Student added successfully')),
                        );
                      }
                    }
                    //     notifier.refreshThisPage(true);

                    Navigator.pop(context);
                  },
                  child: Text(AppLocalizations.of(context)!.add),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
