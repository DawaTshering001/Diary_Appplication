import 'dart:convert';  // Import this for base64 encoding and decoding
import 'dart:typed_data';

class DiaryEntry {
  final int? id;
  final String title;
  String _content;  // Make _content private and mutable
  final DateTime date;
  String? mood;  // Make mood mutable by removing final
  final String? imagePath;
  final Uint8List? image;

  DiaryEntry({
    this.id,
    required this.title,
    required String content,  // Pass content as a parameter
    required this.date,
    this.mood,  // Mood can now be set and modified
    this.imagePath,
    this.image,
  }) : _content = content;  // Initialize _content via constructor

  // Getter for content
  String get content => _content;

  // Setter for content
  set content(String newContent) {
    _content = newContent;
  }

  // Convert DiaryEntry object to a map for saving in the database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': _content,  // Use _content instead of content
      'date': date.toIso8601String(),
      'mood': mood,  // Mood can now be included in the map
      'imagePath': imagePath,
      'image': image != null ? base64Encode(image!) : null,
    };
  }

  // Convert map to a DiaryEntry object
  static DiaryEntry fromMap(Map<String, dynamic> map) {
    return DiaryEntry(
      id: map['id'],
      title: map['title'],
      content: map['content'],  // Directly use the map's content value
      date: DateTime.parse(map['date']),
      mood: map['mood'], // Mood can now be retrieved from the map
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
    String? mood,   // Mood can now be modified here
    String? imagePath,
    Uint8List? image,
  }) {
    return DiaryEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this._content,  // Use _content here
      date: date ?? this.date,
      mood: mood ?? this.mood,   // Set mood here if provided
      imagePath: imagePath ?? this.imagePath,
      image: image ?? this.image,
    );
  }
}