import 'package:flutter/material.dart';

class TimerModel {
  int? hour;
  int minut;
  int day;
  bool isReset;
  TimeOfDay timeOfDay;

  TimerModel({
    this.hour,
    required this.minut,
    required this.day,
    required this.isReset,
    required this.timeOfDay,
  });

  // copyWith method
  TimerModel copyWith({
    int? hour,
    int? minut,
    int? day,
    bool? isReset,
    TimeOfDay? timeOfDay,
  }) {
    return TimerModel(
      hour: hour ?? this.hour,
      minut: minut ?? this.minut,
      day: day ?? this.day,
      isReset: isReset ?? this.isReset,
      timeOfDay: timeOfDay ?? this.timeOfDay,
    );
  }

  // Convert TimerModel to Map
  Map<String, dynamic> toMap() {
    return {
      'hour': hour,
      'minut': minut,
      'day': day,
      'isReset': isReset,
      'timeOfDay': {
        'hour': timeOfDay.hour,
        'minute': timeOfDay.minute,
      },
    };
  }

  // Create TimerModel from Map
  factory TimerModel.fromMap(Map<String, dynamic> map) {
    return TimerModel(
      hour: map['hour'],
      minut: map['minut'],
      day: map['day'],
      isReset: map['isReset'],
      timeOfDay: TimeOfDay(
        hour: map['timeOfDay']['hour'],
        minute: map['timeOfDay']['minute'],
      ),
    );
  }

  // Timer method returning '${hour} ${minut}'
  String timer() {
    return '${hour ?? 0.toDouble()}: ${minut.toDouble()}';
  }
}
