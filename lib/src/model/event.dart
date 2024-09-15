// Event eventFromJson(String str) => Event.fromJson(json.decode(str));
// String eventToJson(Event data) => json.encode(data.toJson());

class Event {
  String title;
  String description;
  String? timeStamp;

  Event({required this.title, required this.description, this.timeStamp});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      title: json["title"],
      description: json["description"],
      timeStamp: json['timestamp'],
    );
  }

  Map<String, dynamic> toJson() =>
      {"title": title, "description": description, "timeStamp": timeStamp};
}
