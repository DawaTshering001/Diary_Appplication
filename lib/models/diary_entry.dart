import 'dart:typed_data';

class DiaryEntry {
  final int? id;
  final String title;
  final String content;
  final DateTime date;
  final String? mood;
  final String? imagePath;  // Path to the image
  final Uint8List? image;   // Alternative: store image as bytes
  
  DiaryEntry({
    this.id,
    required this.title,
    required this.content,
    required this.date,
    this.mood,
    this.imagePath,
    this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date.toIso8601String(),
      'mood': mood,
      'imagePath': imagePath,  // Save image path
      // If storing image as bytes, encode and save it here if needed
      'image': image,  // Or save encoded image bytes as base64 string if using DB
    };
  }

  static DiaryEntry fromMap(Map<String, dynamic> map) {
    return DiaryEntry(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      date: DateTime.parse(map['date']),
      mood: map['mood'],
      imagePath: map['imagePath'], // Retrieve image path
      image: map['image'], // Retrieve image bytes if using in memory or DB
    );
  }
}
