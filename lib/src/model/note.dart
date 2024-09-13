import 'dart:convert';
import 'package:flutter/material.dart';

class Note {
  String id;
  String title;
  String content;
  DateTime createdAt;
  Color color;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.color,
  });

  // Convert a Note into a Map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'color': color.value, // Convert Color to int (its value)
    };
  }

  // Convert a Map into a Note.
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      createdAt: DateTime.parse(map['createdAt']),
      color: Color(map['color']), // Convert int back to Color
    );
  }

  // Convert a Note into a JSON string.
  String toJson() => json.encode(toMap());

  // Convert a JSON string into a Note.
  factory Note.fromJson(String source) => Note.fromMap(json.decode(source));
}
