class Repport {
  final String name;
  int? publication;
  int? vizit;
  String? time;
  final int student;
  String? comment;
  bool isPyonye;
  bool? isSubmited;
  final DateTime submitAt;

  Repport({
    required this.name,
    this.publication,
    this.time,
    this.vizit,
    this.isSubmited,
    required this.isPyonye,
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
      'isSubmited': isSubmited,
      'isPyonye': isPyonye,
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
      isPyonye: map['isPyonye'],
      publication: map['publication'],
      time: map['time'],
      isSubmited: map['isSubmited'],
      vizit: map['vizit'],
      student: map['student'],
      comment: map['comment'],
      submitAt: DateTime.parse(map['submitAt']),
    );
  }

  // CopyWith method for updating fields
  // Add the copyWith method
  Repport copyWith({
    String? name,
    int? publication,
    int? vizit,
    String? time,
    int? student,
    bool? isSubmited,
    String? comment,
    DateTime? submitAt,
    bool? isPyonye, // For updating status
  }) {
    return Repport(
      name: name ?? this.name,
      publication: publication ?? this.publication,
      vizit: vizit ?? this.vizit,
      time: time ?? this.time,
      isSubmited: isSubmited ?? this.isSubmited,
      student: student ?? this.student,
      comment: comment ?? this.comment,
      submitAt: submitAt ?? this.submitAt,
      isPyonye: isPyonye ?? this.isPyonye, // Update the isPyonye field
    );
  }
}
