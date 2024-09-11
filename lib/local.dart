import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'src/model/student.dart';

class StudentPreferences {
  static final StudentPreferences _instance = StudentPreferences._internal();

  factory StudentPreferences() {
    return _instance;
  }

  StudentPreferences._internal();

  static const String _studentKey = 'students';

  // Initialize SharedPreferences instance
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Add a student
  Future<void> addStudent(Student student) async {
    final List<Student> students = await getAllStudents();
    students.add(student);
    await _saveStudents(students);
  }

  // Get all students
  Future<List<Student>> getAllStudents() async {
    final String? studentJson = _prefs?.getString(_studentKey);
    if (studentJson != null) {
      List<dynamic> jsonList = jsonDecode(studentJson);
      return jsonList.map((json) => Student.fromMap(json)).toList();
    }
    return [];
  }

  // Remove a student by name
  Future<void> removeStudent(String name) async {
    final List<Student> students = await getAllStudents();
    students.removeWhere((student) => student.name == name);
    await _saveStudents(students);
  }

  // Delete all students
  Future<void> deleteAllStudents() async {
    await _prefs?.remove(_studentKey);
  }

  // Save the updated list of students to SharedPreferences
  Future<void> _saveStudents(List<Student> students) async {
    final String studentJson = jsonEncode(students.map((student) => student.toMap()).toList());
    await _prefs?.setString(_studentKey, studentJson);
  }
}
