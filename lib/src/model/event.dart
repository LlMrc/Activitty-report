class Event {
  String? title;
  String? description;
  String? timeStamp;
  bool? pyonye;

  Event({
     this.title,
     this.description,
    this.timeStamp,
    this.pyonye,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      title: json['title'],
      description: json['description'],
      timeStamp: json['timestamp'],
      pyonye: json['pyonye'],
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'timeStamp': timeStamp,
        'pyonye': pyonye,
      };

  // Add the copyWith method
  Event copyWith({
    String? title,
    String? description,
    String? timeStamp,
    bool? pyonye,
  }) {
    return Event(
      title: title ?? this.title, // If the new title is null, keep the old one
      description: description ?? this.description,
      timeStamp: timeStamp ?? this.timeStamp,
      pyonye: pyonye ?? this.pyonye,
    );
  }

   // Method to update pyonye field
  void updatePyonye(bool newPyonye) {
    pyonye = newPyonye;
  }
}
