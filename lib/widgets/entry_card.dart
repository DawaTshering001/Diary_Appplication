import 'package:flutter/material.dart';
import '../models/diary_entry.dart';
import '../screens/entry_detail_page.dart'; // Import the EntryDetailPage directly

class EntryCard extends StatelessWidget {
  final DiaryEntry entry;
  final VoidCallback onDelete;

  const EntryCard({
    Key? key,
    required this.entry,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        onTap: () {
          // Navigate directly to EntryDetailPage
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EntryDetailPage(entry: entry),
            ),
          );
        },
        contentPadding: EdgeInsets.all(12.0),
        title: Text(
          entry.title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 6),
            Text(
              entry.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.black.withOpacity(0.7)),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Date: ${entry.date.year}-${entry.date.month}-${entry.date.day}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                if (entry.mood != null)
                  Text(
                    'Mood: ${entry.mood}',
                    style: TextStyle(fontSize: 12),
                  ),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.redAccent),
          onPressed: () {
            _confirmDelete(context);
          },
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Entry'),
          content: Text('Are you sure you want to delete this entry?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                onDelete();
                Navigator.of(context).pop();
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
} 