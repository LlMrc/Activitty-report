import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/event.dart';
import '../model/note.dart';
import '../model/repo.dart';
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

  // Add a Repo object to the list in SharedPreferences
  Future<void> addRepo(Repo repo) async {
    List<String> repoList = _prefs.getStringList(keyRepo) ?? [];

    // Convert Repo to JSON string and add to list
    String repoJson = jsonEncode(repo.toJson());
    repoList.add(repoJson);

    // Save the updated list in SharedPreferences
    await _prefs.setStringList(keyRepo, repoList);
  }

  // Delete a Repo object by title (or any unique identifier)
  Future<void> deleteRepo(String title) async {
    List<String> repoList = _prefs.getStringList(keyRepo) ?? [];

    // Filter the list to remove the Repo with the matching title
    repoList.removeWhere((repoJson) {
      Map<String, dynamic> repoMap = jsonDecode(repoJson);
      return repoMap['title'] == title;
    });

    // Save the updated list in SharedPreferences
    await _prefs.setStringList(keyRepo, repoList);
  }

  // Get all Repo objects from SharedPreferences
  List<Repo> getRepos() {
    List<String> repoList = _prefs.getStringList(keyRepo) ?? [];

    // Convert the JSON strings back to Repo objects
    return repoList.map((repoJson) {
      return Repo.fromJson(jsonDecode(repoJson));
    }).toList();
  }

  //Enable natification
  void enableNotification(bool newValue) async {
    await _prefs.setBool(keyNotification, newValue);
  }

  bool getNotification() {
    return _prefs.getBool(keyNotification) ?? false;
  }

  //Enable Timer
  void upDateTimer(bool newValue) async {
    await _prefs.setBool(keyTimer, newValue);
  }

  bool getTimer() {
    return _prefs.getBool(keyTimer) ?? false;
  }
}
