import 'package:flutter/material.dart';
import '../models/diary_entry.dart';
import '../services/database_service.dart';

class EntryDetailPage extends StatefulWidget {
  final DiaryEntry entry;
  final DatabaseService _dbService = DatabaseService();

  EntryDetailPage({Key? key, required this.entry}) : super(key: key);

  @override
  _EntryDetailPageState createState() => _EntryDetailPageState();
}

class _EntryDetailPageState extends State<EntryDetailPage> {
  late TextEditingController _contentController;
  bool _isEditing = false; // Track whether the user is in edit mode

  List<String> moods = ['😊', '😢', '😄', '😡', '😐']; // Emoji moods
  String? selectedMood;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(text: widget.entry.content);
    selectedMood = widget.entry.mood; // Initialize selected mood
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.entry.title),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              if (_isEditing) {
                // Save the changes when in editing mode
                _saveEntry(context);
              } else {
                // Switch to edit mode
                setState(() {
                  _isEditing = true;
                });
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _confirmDelete(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the date
            Text(
              'Date: ${widget.entry.date.year}-${widget.entry.date.month}-${widget.entry.date.day}',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 8),

            // Mood selection using emojis
            DropdownButton<String>(
              value: selectedMood,
              hint: Text('Select Mood'),
              items: moods.map((String mood) {
                return DropdownMenuItem<String>(
                  value: mood,
                  child: Text(mood, style: TextStyle(fontSize: 24)), // Display emoji larger
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedMood = newValue;
                  widget.entry.mood = newValue; // Update the mood in the entry
                });
              },
            ),
            SizedBox(height: 16),

            // Content editor area with formatting options
            if (_isEditing) ...[
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.format_bold),
                    onPressed: () => _toggleBold(),
                  ),
                  IconButton(
                    icon: Icon(Icons.format_italic),
                    onPressed: () => _toggleItalic(),
                  ),
                  IconButton(
                    icon: Icon(Icons.format_underline),
                    onPressed: () => _toggleUnderline(),
                  ),
                ],
              ),
              TextField(
                controller: _contentController,
                maxLines: null,
                decoration: InputDecoration(labelText: 'Content'),
                onChanged: (value) {
                  widget.entry.content = value; // Update the content of the entry
                },
              ),
            ] else ...[
              SingleChildScrollView(
                child: Text(
                  widget.entry.content,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _toggleBold() {
    setState(() {
      String currentText = _contentController.text;
      if (currentText.endsWith('**')) {
        currentText = currentText.substring(0, currentText.length - 2);
      } else {
        currentText += '**'; // Simple marker for bold
      }
      _contentController.text = currentText;
      _contentController.selection = TextSelection.fromPosition(TextPosition(offset: currentText.length)); // Move cursor to end
    });
  }

  void _toggleItalic() {
    setState(() {
      String currentText = _contentController.text;
      if (currentText.endsWith('*')) {
        currentText = currentText.substring(0, currentText.length - 1);
      } else {
        currentText += '*'; // Simple marker for italic
      }
      _contentController.text = currentText;
      _contentController.selection = TextSelection.fromPosition(TextPosition(offset: currentText.length)); // Move cursor to end
    });
  }

  void _toggleUnderline() {
    setState(() {
      String currentText = _contentController.text;
      if (currentText.endsWith('__')) {
        currentText = currentText.substring(0, currentText.length - 2);
      } else {
        currentText += '__'; // Simple marker for underline
      }
      _contentController.text = currentText;
      _contentController.selection = TextSelection.fromPosition(TextPosition(offset: currentText.length)); // Move cursor to end
    });
  }

  Future<void> _saveEntry(BuildContext context) async {
    try {
      if (widget.entry.id != null) {
        widget.entry.content = _contentController.text; // Save content directly from controller
        await widget._dbService.updateEntry(widget.entry);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Entry updated successfully')),
        );
        setState(() {
          _isEditing = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: Entry ID is null.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update entry: $e')),
      );
    }
  }

  Future<void> _confirmDelete(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Entry'),
          content: Text('Are you sure you want to delete this entry?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Close the dialog
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _deleteEntryLocally(context);
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Go back to the previous screen
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteEntryLocally(BuildContext context) async {
    try {
      if (widget.entry.id != null) {
        await widget._dbService.deleteEntry(widget.entry.id!); // Delete entry from the database
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Entry deleted successfully')),
        );
        Navigator.of(context).pop(); // Close current screen (go back)
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: Entry ID is null.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete entry: $e')),
      );
    }
  }
}