import 'package:flutter/material.dart';
import '../models/diary_entry.dart';
import '../services/database_service.dart';

class EntryDetailPage extends StatelessWidget {
  final DiaryEntry entry;
  final DatabaseService _dbService = DatabaseService();

  EntryDetailPage({Key? key, required this.entry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(entry.title),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(context, '/editEntry', arguments: entry);
            },
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              _exportEntry(context);
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
            Text(
              'Date: ${entry.date.year}-${entry.date.month}-${entry.date.day}',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 16),
            Text(
              entry.content,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            if (entry.mood != null)
              Text(
                'Mood: ${entry.mood}',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
          ],
        ),
      ),
    );
  }

  void _exportEntry(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Export functionality to be implemented')),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    // Show confirmation dialog for deletion
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
                // Proceed with the deletion
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
      if (entry.id != null) {
        await _dbService.deleteEntry(entry.id!); // Delete entry from the database
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
      // Error handling
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete entry: $e')),
      );
    }
  }
}
