class Repo {
  List<DateTime> dates;
  String title;
  String content;

  Repo({
    required this.dates,
    required this.title,
    required this.content,
  });

  // Convert a Repo object to JSON
  Map<String, dynamic> toJson() {
    return {
      'dates': dates.map((date) => date.toIso8601String()).toList(),
      'title': title,
      'content': content,
    };
  }

  // Convert JSON to a Repo object
  factory Repo.fromJson(Map<String, dynamic> json) {
    return Repo(
      dates: (json['dates'] as List<dynamic>)
          .map((date) => DateTime.parse(date as String))
          .toList(),
      title: json['title'],
      content: json['content'],
    );
  }
}
