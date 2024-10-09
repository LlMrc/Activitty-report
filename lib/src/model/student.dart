class Student {
  final String name;
  String? phoneNumber;
  final DateTime dateAdded;
  String? comment;
  int? lesson;
  String? schedule;

  Student({
    required this.name,
    this.phoneNumber,
    this.comment,
    this.lesson,
    required this.dateAdded,
    this.schedule,
  });

  // Method to convert a Student object to a map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'comment': comment,
      'lesson': lesson,
      'phoneNumber': phoneNumber,
      'dateAdded': dateAdded.toIso8601String(),
      'schedule': schedule,
    };
  }

  // Method to create a Student object from a map
  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      name: map['name'],
      comment: map['comment'],
      lesson: map['lesson'],
      phoneNumber: map['phoneNumber'],
      dateAdded: DateTime.parse(map['dateAdded']),
      schedule: map['schedule'],
    );
  }

  // Method to create a copy of the Student object with updated fields
  Student copyWith({
    String? name,
    String? phoneNumber,
    DateTime? dateAdded,
    String? comment,
    int? lesson,
    String? schedule,
  }) {
    return Student(
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateAdded: dateAdded ?? this.dateAdded,
      comment: comment ?? this.comment,
      lesson: lesson ?? this.lesson,
      schedule: schedule ?? this.schedule,
    );
  }
}
