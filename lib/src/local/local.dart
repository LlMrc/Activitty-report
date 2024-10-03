import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/event.dart';
import '../model/note.dart';

import '../model/report.dart';
import '../model/student.dart';
import '../model/timer.dart';

class SharedPreferencesSingleton {
  static final SharedPreferencesSingleton _instance =
      SharedPreferencesSingleton._internal();

  factory SharedPreferencesSingleton() {
    return _instance;
  }

  SharedPreferencesSingleton._internal();
  static const String keyNote = 'notes';
  static const String keyEvents = 'events';
  static const String keyEventsRange = 'events_range';
  static const String keyStudent = 'students';
  //static const String keyRepo = 'repoList';
  static const String keyNotification = 'notification';
  static const String keyTimer = 'timer';
  static const String keyReport = 'repport_id';
  // Initialize SharedPreferences instance
  late SharedPreferences _prefs;

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
    final String? studentJson = _prefs.getString(keyStudent);
    if (studentJson != null) {
      List<dynamic> jsonList = jsonDecode(studentJson);
      return jsonList.map((json) => Student.fromMap(json)).toList();
    }
    return [];
  }

  Future<void> updateStudent(Student updatedStudent) async {
    final List<Student> students = await getAllStudents();
    final int index =
        students.indexWhere((student) => student.name == updatedStudent.name);

    if (index != -1) {
      // Get the current student
      Student currentStudent = students[index];

      // If the current dateAdded is different from now, update it
      if (currentStudent.dateAdded != DateTime.now()) {
        updatedStudent = updatedStudent.copyWith(dateAdded: DateTime.now());
      }

      // Update the student
      students[index] = updatedStudent;
      await _saveStudents(students); // Save the updated list
    }
  }

  Future<void> updateStudentComment(
      Student updatedStudent, String newComment) async {
    final List<Student> students = await getAllStudents();
    final int index =
        students.indexWhere((student) => student.name == updatedStudent.name);

    if (index != -1) {
      // Get the current student
      Student currentStudent = students[index];

      // If the current dateAdded is different from now, update it
      if (currentStudent.dateAdded != DateTime.now()) {
        updatedStudent = updatedStudent.copyWith(comment: newComment);
      }

      // Update the student
      students[index] = updatedStudent;
      await _saveStudents(students); // Save the updated list
    }
  }

// Get the count for a specific student by name
  int getStudentCount(Student student) {
    // Return the count if the student is found, otherwise return null
    return student.lesson ?? 0;
  }

  // Remove a student by name
  Future<void> removeStudent(Student currentStudent) async {
    final List<Student> students = await getAllStudents();
    students.removeWhere((student) => student.name == currentStudent.name);
    await _saveStudents(students);
  }

  // Delete all students
  Future<void> deleteAllStudents() async {
    await _prefs.remove(keyStudent);
  }

  // Save the updated list of students to SharedPreferences
  Future<void> _saveStudents(List<Student> students) async {
    final String studentJson =
        jsonEncode(students.map((student) => student.toMap()).toList());
    await _prefs.setString(keyStudent, studentJson);
  }

  // Save or update a note.
  Future<void> saveOrUpdateNote(Note note) async {
    final notesList = _prefs.getStringList(keyNote) ?? [];
    final noteJson = note.toJson();
    bool updated = false;

    for (int i = 0; i < notesList.length; i++) {
      final existingNote = Note.fromJson(notesList[i]);
      if (existingNote.id == note.id) {
        notesList[i] = noteJson; // Update the note
        updated = true;
        break;
      }
    }

    if (!updated) {
      notesList.add(noteJson); // Add new note if not already present
    }

    await _prefs.setStringList(keyNote, notesList);
  }

  // Retrieve all notes.
  List<Note> getNotes() {
    final notesList = _prefs.getStringList(keyNote) ?? [];
    return notesList.map((noteJson) => Note.fromJson(noteJson)).toList();
  }

  // Delete a note by ID.
  Future<void> deleteNoteById(String id) async {
    final notesList = _prefs.getStringList(keyNote) ?? [];
    notesList.removeWhere((note) => Note.fromJson(note).id == id);
    await _prefs.setStringList(keyNote, notesList);
  }

  //event

//SAVE EVENT
  Future<void> saveEvents(Map<DateTime, List<Event>> events) async {
    final eventsJson = _encodeEvents(events);
    debugPrint("Saving events: $eventsJson");
    await _prefs.setString(keyEvents, eventsJson);
  }

  Future<void> removeEvent() async {
    Map<DateTime, List<Event>> events = getEvents();
    events.clear();

    debugPrint("Events after removal: $events");
  }

  Map<DateTime, List<Event>> getEvents() {
    final eventsJson = _prefs.getString(keyEvents);

    return eventsJson != null ? _decodeEvents(eventsJson) : {};
  }

  String _encodeEvents(Map<DateTime, List<Event>> events) {
    return json.encode(events.map(
      (key, value) => MapEntry(
          key.toIso8601String(), value.map((e) => e.toJson()).toList()),
    ));
  }

  Map<DateTime, List<Event>> _decodeEvents(String eventsJson) {
    final Map<String, dynamic> jsonMap = json.decode(eventsJson);
    return jsonMap.map((key, value) {
      final DateTime dateTime = DateTime.parse(key);
      final List<Event> events =
          (value as List).map((e) => Event.fromJson(e)).toList();
      return MapEntry(dateTime, events);
    });
  }

//Users can select Date range  when saving event
  Future<void> saveEventsWithDateRange(
      Map<List<DateTime>, Event> events) async {
    final eventsJson = _encodeEventsWithDateRange(events);
    //debugPrint("Saving events with date range: $eventsJson");
    await _prefs.setString(keyEventsRange, eventsJson); // Use a different key
  }

  String _encodeEventsWithDateRange(Map<List<DateTime>, Event> events) {
    return json.encode(events.map(
      (key, value) => MapEntry(
        key
            .map((date) => date.toIso8601String())
            .join(' to '), // Encode the list of DateTimes as a string
        value.toJson(), // Ensure Event has a toJson() method
      ),
    ));
  }

  Map<List<DateTime>, Event> _decodeEventsWithDateRange(String eventsJson) {
    final Map<String, dynamic> jsonMap = json.decode(eventsJson);
    return jsonMap.map((key, value) {
      // Split the key back into two DateTime objects
      final List<DateTime> dateRange = key
          .split(' to ')
          .map((dateString) => DateTime.parse(dateString))
          .toList();

      // Decode the Event from JSON
      final Event event = Event.fromJson(value);
      return MapEntry(dateRange, event);
    });
  }

  Map<List<DateTime>, Event> getEventsWithDateRange() {
    final eventsJson = _prefs.getString(keyEventsRange);
    return eventsJson != null ? _decodeEventsWithDateRange(eventsJson) : {};
  }

  //Enable natification
  void enableNotification(bool newValue) async {
    await _prefs.setBool(keyNotification, newValue);
  }

  bool getNotification() {
    return _prefs.getBool(keyNotification) ?? false;
  }

  // Save a list of Repports
  Future<void> saveRepport(Repport repport) async {
    List<Repport> repports = getAllRepports();
    repports.add(repport);
    // Convert the list of Repport objects to JSON and save it
    String repportListJson =
        jsonEncode(repports.map((e) => e.toMap()).toList());
    await _prefs.setString(keyReport, repportListJson);
  }

  Future<void> updateRepport(Repport updatedRepport) async {
    List<Repport> repports = getAllRepports();
    final DateTime now = DateTime.now();

    // Check if there is a report for the current month and year
    int indexToUpdate = repports.indexWhere((repport) =>
        repport.submitAt.month == now.month &&
        repport.submitAt.year == now.year);

    if (indexToUpdate != -1) {
      // Update the existing report

      repports[indexToUpdate] = updatedRepport;
    } else {
      // Optionally, handle the case where no report exists to update
      debugPrint('No report found for update, adding new one.');
      repports.add(updatedRepport); // Add a new report if no match found
    }

    // Save the updated list back to SharedPreferences
    String updatedRepportJson =
        jsonEncode(repports.map((r) => r.toMap()).toList());
    await _prefs.setString(
        SharedPreferencesSingleton.keyReport, updatedRepportJson);

    debugPrint('Report updated successfully');
  }

  // Delete a Repport by name and student ID
  Future<void> deleteUnsubmitedReport() async {
    // Get the list of all reports
    List<Repport> repports = getAllRepports();

    if (repports.isNotEmpty) {
      // Filter the list to remove reports that match the given month and year
      repports.removeWhere((repport) => repport.isSubmited != true);

      // If no reports are left, remove the key from SharedPreferences
      if (repports.isEmpty) {
        await _prefs.remove(keyReport);
      } else {
        // Otherwise, save the updated list back to SharedPreferences
        String updatedRepportJson =
            jsonEncode(repports.map((r) => r.toMap()).toList());
        await _prefs.setString(keyReport, updatedRepportJson);
      }

      debugPrint('Reports  deleted successfully');
    } else {
      debugPrint('No reports found for deletion');
    }
  }

  // Delete a Repport by name and student ID
  Future<void> deleteRepportByMonthAndYear(DateTime dateToDelete) async {
    // Get the list of all reports
    List<Repport> repports = getAllRepports();

    if (repports.isNotEmpty) {
      // Filter the list to remove reports that match the given month and year
      repports.removeWhere((repport) =>
          repport.submitAt.month == dateToDelete.month &&
          repport.submitAt.year == dateToDelete.year);

      // If no reports are left, remove the key from SharedPreferences
      if (repports.isEmpty) {
        await _prefs.remove(keyReport);
      } else {
        // Otherwise, save the updated list back to SharedPreferences
        String updatedRepportJson =
            jsonEncode(repports.map((r) => r.toMap()).toList());
        await _prefs.setString(keyReport, updatedRepportJson);
      }

      debugPrint(
          'Reports for ${dateToDelete.month}/${dateToDelete.year} deleted successfully');
    } else {
      debugPrint('No reports found for deletion');
    }
  }

  Repport? getRepport() {
    List<Repport> repports = getAllRepports();
    DateTime date = DateTime.now();
    try {
      return repports.lastWhere(
        (repport) => repport.submitAt.month == date.month,
      );
    } catch (e) {
      // You can log the error if needed
      debugPrint('Exception: $e');
    }

    return null; // Return null if no report is found for the current month
  }

  // Retrieve all Repports
  List<Repport> getAllRepports() {
    String? repportListJson = _prefs.getString(keyReport);
    if (repportListJson != null) {
      List<dynamic> decodedList = jsonDecode(repportListJson);
      return decodedList.map((item) => Repport.fromMap(item)).toList();
    }
    return [];
  }
//************************************ TIMER ************************** */

  // Save or update TimerModel
  Future<void> saveTimer(TimerModel timer) async {
    List<TimerModel> allTimers = getAllTimers();

    // Check if the timer already exists
    int index = allTimers.indexWhere(
        (t) => t.day == timer.day); // Assuming 'day' is the unique identifier

    if (index != -1) {
      // Update the existing timer
      allTimers[index] = timer;
    } else {
      // Add a new timer
      allTimers.add(timer);
    }

    String jsonTimers = jsonEncode(allTimers.map((t) => t.toMap()).toList());
    await _prefs.setString('timerList', jsonTimers);
  }

  Future<void> updateTimeOfDay(TimeOfDay newTimeOfDay) async {
    List<TimerModel> allTimers = getAllTimers();
    int currentDay = DateTime.now().day;

    // Find timers with matching day and update them
    List<TimerModel> updatedTimers = allTimers.map((timer) {
      if (timer.day == currentDay) {
        return timer.copyWith(
          timeOfDay: newTimeOfDay, // Update timeOfDay if provided
        );
      }
      return timer;
    }).toList();

    // Save updated list to SharedPreferences
    String jsonTimers =
        jsonEncode(updatedTimers.map((t) => t.toMap()).toList());
    await _prefs.setString('timerList', jsonTimers);

    debugPrint('CURRENT TIMEOfDay IS SAFELY UPDATED ${newTimeOfDay.minute}');
  }

  Future<void> updateTimerMinutAndHour(Duration time,
      {TimeOfDay? newTimeOfDay}) async {
    List<TimerModel> allTimers = getAllTimers();
    int currentDay = DateTime.now().day;

    // Find timers with matching day and update them
    List<TimerModel> updatedTimers = allTimers.map((timer) {
      if (timer.day == currentDay) {
        return timer.copyWith(
          minut: time.inMinutes,
          hour: time.inHours,
          timeOfDay:
              newTimeOfDay ?? timer.timeOfDay, // Update timeOfDay if provided
        );
      }
      return timer;
    }).toList();

    // Save updated list to SharedPreferences
    String jsonTimers =
        jsonEncode(updatedTimers.map((t) => t.toMap()).toList());
    await _prefs.setString('timerList', jsonTimers);

    debugPrint('CURRENT TIMER IS SAFELY UPDATED ${time.inSeconds}');
  }

  // Delete TimerModel where month equals DateTime.now().month
  Future<void> deleteTimer() async {
    List<TimerModel> allTimers = getAllTimers();
    int currentDay = DateTime.now().day;

    // Remove timers where the month matches the current month
    allTimers.removeWhere((timer) => timer.day == currentDay);

    // Save updated list to SharedPreferences
    String jsonTimers = jsonEncode(allTimers.map((t) => t.toMap()).toList());
    await _prefs.setString('timerList', jsonTimers);
  }

  // Retrieve all TimerModel objects
  List<TimerModel> getAllTimers() {
    String? timerListJson = _prefs.getString('timerList');
    if (timerListJson != null) {
      List<dynamic> decodedList = jsonDecode(timerListJson);
      return decodedList.map((item) => TimerModel.fromMap(item)).toList();
    }
    return [];
  }

  // Retrieve the TimerModel for the current month
  TimerModel? getTimer() {
    final date = DateTime.now();
    String? timerListJson = _prefs.getString('timerList');

    if (timerListJson != null) {
      List<dynamic> decodedList = jsonDecode(timerListJson);
      List<TimerModel> timerList =
          decodedList.map((item) => TimerModel.fromMap(item)).toList();

      try {
        // Find the first TimerModel where the month matches the current month
        return timerList.firstWhere((item) => item.day == date.day);
      } catch (e) {
        // Return null if no matching TimerModel is found
        return null;
      }
    }
    return null;
  }

  void saveName(String name) {
    _prefs.setString('user_name', name);
  }

  String? getName() {
    return _prefs.getString('user_name');
  }

  Future<void> updateName(String newName) async {
    _prefs.setString('user_name', newName);
    saveName(newName);
  }
}
