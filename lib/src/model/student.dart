class Student {
  final String name;
  String? phoneNumber;
  final DateTime dateAdded;
  String? comment;
  int? lesson;
  String? address;

  Student({
    required this.name,
    this.phoneNumber,
    this.comment,
    this.lesson,
    required this.dateAdded,
    this.address,
  });

  // Method to convert a Student object to a map (for saving in databases, etc.)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'comment': comment,
      'lesson': lesson,
      'phoneNumber': phoneNumber,
      'dateAdded': dateAdded.toIso8601String(),
      'address': address,
    };
  }

  // Method to create a Student object from a map (for retrieving from databases, etc.)
  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      name: map['name'],
      comment: map['comment'],
      lesson: map['lesson'],
      phoneNumber: map['phoneNumber'],
      dateAdded: DateTime.parse(map['dateAdded']),
      address: map['address'],
    );
  }
}
