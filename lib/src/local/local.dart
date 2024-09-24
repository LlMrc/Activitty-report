import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/event.dart';
import '../model/note.dart';

import '../model/student.dart';

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
  static const String keyRepo = 'repoList';
  static const String keyNotification = 'notification';
  static const String keyTimer = 'timer';

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

  // Remove a student by name
  Future<void> removeStudent(String name) async {
    final List<Student> students = await getAllStudents();
    students.removeWhere((student) => student.name == name);
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
    debugPrint("Saving events with date range: $eventsJson");
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

Future<bool?> getPyonye(DateTime targetDate, {DateTime? endDate}) async {
    final eventsJson = _prefs.getString(keyEventsRange);
    if (eventsJson == null) return null; // No events saved

    // Decode the stored events
    final events = _decodeEventsWithDateRange(eventsJson);

    // Check if it's a single date event
    if (endDate == null) {
      // Look for the event with a single target date
      for (List<DateTime> dateRange in events.keys) {
        if (dateRange.length == 1 && dateRange.first == targetDate) {
          // Return the pyonye value from the Event
          return events[dateRange]?.pyonye;
        }
      }
    } else {
      // Look for the event with a date range
      for (List<DateTime> dateRange in events.keys) {
        if (dateRange.first == targetDate && dateRange.last == endDate) {
          // Return the pyonye value from the Event
          return events[dateRange]?.pyonye;
        }
      }
    }

    return null; // No event found for the single date or date range
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

 
}
