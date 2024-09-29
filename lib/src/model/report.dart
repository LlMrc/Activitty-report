class Repport {
  final String name;
  int? publication;
  int? vizit;
  String? time;
  final int student;
  String? comment;
  final DateTime submitAt;

  Repport({
    required this.name,
    this.publication,
    this.time,
    this.vizit,
    required this.student,
    this.comment,
   required this.submitAt,
  });

  // Method to convert Repport to a Map (for saving to databases or preferences)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'publication': publication,
      'time': time,
      'vizit': vizit,
      'student': student,
      'comment': comment,
      'submitAt': submitAt.toIso8601String(),
    };
  }

  // Method to create a Repport object from a Map (for retrieving from databases or preferences)
  factory Repport.fromMap(Map<String, dynamic> map) {
    return Repport(
      name: map['name'],
      publication: map['publication'],
      time: map['time'],
      vizit: map['vizit'],
      student: map['student'],
      comment: map['comment'],
      submitAt: DateTime.parse(map['submitAt']),
    );
  }

  // CopyWith method for updating fields
  Repport copyWith({
    String? name,
    int? publication,
    String? time,
    int? vizit,
    int? student,
    String? comment,
    DateTime? submitAt,
  }) {
    return Repport(
      name: name ?? this.name,
      publication: publication ?? this.publication,
      time: time ?? this.time,
      vizit: vizit ?? this.vizit,
      student: student ?? this.student,
      comment: comment ?? this.comment,
      submitAt: submitAt ?? this.submitAt,
    );
  }
}
