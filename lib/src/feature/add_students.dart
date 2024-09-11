import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../local.dart';
import '../model/student.dart'; // For formatting the Date


class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({Key? key}) : super(key: key);

  @override
  _AddStudentScreenState createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  // Method to pick date
  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Method to add the student
  Future<void> _addStudent() async {
    if (_formKey.currentState!.validate()) {
      // Create a new Student object
      final student = Student(
        name: _nameController.text,
        phoneNumber: _phoneNumberController.text,
        dateAdded: _selectedDate,
        address: _addressController.text,
      );

      // Add student to SharedPreferences
      await StudentPreferences().addStudent(student);

      // Clear the form
      _nameController.clear();
      _phoneNumberController.clear();
      _addressController.clear();
      setState(() {
        _selectedDate = DateTime.now();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Student added successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Student'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
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
              TextFormField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value != null && value.isNotEmpty && value.length < 10) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
              ),
              const SizedBox(height: 20),
              ListTile(
                title: Text(
                    'Date Added: ${DateFormat.yMMMd().format(_selectedDate)}'),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _pickDate(context),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addStudent,
                child: const Text('Add Student'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
