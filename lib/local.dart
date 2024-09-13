import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'src/model/event.dart';
import 'src/model/note.dart';
import 'src/model/student.dart';

class SharedPreferencesSingleton {
  static final SharedPreferencesSingleton _instance =
      SharedPreferencesSingleton._internal();

  factory SharedPreferencesSingleton() {
    return _instance;
  }

  SharedPreferencesSingleton._internal();
  static const String keyNote = 'notes';
  static const String keyEvents = 'events';
  static const String _studentKey = 'students';

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
    final String? studentJson = _prefs.getString(_studentKey);
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
    await _prefs.remove(_studentKey);
  }

  // Save the updated list of students to SharedPreferences
  Future<void> _saveStudents(List<Student> students) async {
    final String studentJson =
        jsonEncode(students.map((student) => student.toMap()).toList());
    await _prefs.setString(_studentKey, studentJson);
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
}
