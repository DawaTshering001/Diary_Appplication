import 'dart:convert';  // Import this for base64 encoding and decoding
import 'dart:typed_data';

class DiaryEntry {
  final int? id;
  final String title;
  final String content;
  final DateTime date;
  final String? mood;
  final String? imagePath;
  final Uint8List? image;

  DiaryEntry({
    this.id,
    required this.title,
    required this.content,
    required this.date,
    this.mood,
    this.imagePath,
    this.image,
  });

  // Convert DiaryEntry object to a map for saving in the database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date.toIso8601String(),
      'mood': mood,
      'imagePath': imagePath,
      'image': image != null ? base64Encode(image!) : null,
    };
  }

  // Convert map to a DiaryEntry object
  static DiaryEntry fromMap(Map<String, dynamic> map) {
    return DiaryEntry(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      date: DateTime.parse(map['date']),
      mood: map['mood'],
      imagePath: map['imagePath'],
      image: map['image'] != null ? base64Decode(map['image']) : null,  // Decode the base64 string to Uint8List
    );
  }

  // Add a copyWith method to create a copy with modified values
  DiaryEntry copyWith({
    int? id,
    String? title,
    String? content,
    DateTime? date,
    String? mood,
    String? imagePath,
    Uint8List? image,
  }) {
    return DiaryEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
      mood: mood ?? this.mood,
      imagePath: imagePath ?? this.imagePath,
      image: image ?? this.image,
    );
  }
}
