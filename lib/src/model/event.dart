class Event {
  String? title;
  String? comment;
  String? timeStamp;
  bool? pyonye;

  Event({
     this.title,
     this.comment,
    this.timeStamp,
    this.pyonye,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      title: json['title'],
      comment: json['comment'],
      timeStamp: json['timestamp'],
      pyonye: json['pyonye'],
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'comment': comment,
        'timeStamp': timeStamp,
        'pyonye': pyonye,
      };

  // Add the copyWith method
  Event copyWith({
    String? title,
    String? timeStamp,
    bool? pyonye,
    String? comment
  }) {
    return Event(
      title: title ?? this.title, // If the new title is null, keep the old one
      comment: comment ?? this.comment,
      timeStamp: timeStamp ?? this.timeStamp,
      pyonye: pyonye ?? this.pyonye,
    );
  }

   // Method to update pyonye field
  void updatePyonye(bool newPyonye) {
    pyonye = newPyonye;
  }
}
