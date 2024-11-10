class DiaryEntry {
  final int? id;
  final String title;
  final String content;
  final DateTime date;
  final String? mood;

  DiaryEntry({this.id, required this.title, required this.content, required this.date, this.mood});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date.toIso8601String(),
      'mood': mood,
    };
  }

  static DiaryEntry fromMap(Map<String, dynamic> map) {
    return DiaryEntry(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      date: DateTime.parse(map['date']),
      mood: map['mood'],
    );
  }
}
