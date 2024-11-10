import 'package:flutter/material.dart';

class MoodSelector extends StatelessWidget {
  final ValueChanged<String?> onMoodSelected;  // Use ValueChanged instead of Function

  MoodSelector({required this.onMoodSelected});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      hint: Text('Select Mood'),
      onChanged: onMoodSelected,  // onChanged expects a ValueChanged<String?>
      items: ['Happy', 'Sad', 'Neutral'].map((mood) {
        return DropdownMenuItem<String>(
          value: mood,
          child: Text(mood),
        );
      }).toList(),
    );
  }
}
