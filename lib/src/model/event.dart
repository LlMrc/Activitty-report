// Event eventFromJson(String str) => Event.fromJson(json.decode(str));
// String eventToJson(Event data) => json.encode(data.toJson());

class Event {
  String title;
  String description;
  String? timeStamp;
  bool? pyonye;

  Event({required this.title, this.pyonye, required this.description, this.timeStamp});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      title: json["title"],
      description: json["description"],
      timeStamp: json['timestamp'],
      pyonye:  json['pyonye']
    );
  }

  Map<String, dynamic> toJson() =>
      {"title": title, "description": description, "timeStamp": timeStamp, 'pyonye': pyonye};
}
