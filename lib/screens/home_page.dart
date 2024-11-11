import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:provider/provider.dart';

import '../providers/entry_provider.dart';
import '../widgets/entry_card.dart';
import 'about_us_page.dart';
import 'add_edit_entry_page.dart';
import 'privacy_security_page.dart';
import 'lock_page.dart';
import 'reminder_page.dart';
import 'settings_page.dart';
import '../screens/themes_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime? _selectedDate;
  final TextEditingController _searchController = TextEditingController();

  // Add a GlobalKey for the Scaffold
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  void _loadEntries() {
    Provider.of<EntryProvider>(context, listen: false).fetchEntries();
  }

  // Function to handle date selection
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return CustomDatePickerDialog(
          currentDate: _selectedDate ?? DateTime.now(),
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Clear the selected date to show all entries
  void _clearDateFilter() {
    setState(() {
      _selectedDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Diary App'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddEditEntryPage()),
              );
            },
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(120.0), // Adjusted size
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Full-width Search TextField for text-based search
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      // Date picker button
                      IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context),
                      ),
                      // Display the selected date or placeholder
                      Text(
                        _selectedDate == null
                            ? 'Search by date: Pick a date for search'
                            : 'Selected Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}',
                        style: TextStyle(fontSize: 16),
                      ),
                      // Show All Entries button aligned with the date picker
                      if (_selectedDate != null)
                        ElevatedButton(
                          onPressed: _clearDateFilter,
                          child: Text("Show All Entries"),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
              child: Text(
                'Diary App Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.format_paint),
              title: Text('Themes'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ThemesPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.alarm),
              title: Text('Reminder'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReminderPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.lock),
              title: Text('Lock your Diary'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LockPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About Us'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutUsPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.lock),
              title: Text('Privacy & Security'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PrivacySecurityPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Consumer<EntryProvider>(
        builder: (context, provider, _) {
          final filteredEntries = _selectedDate == null
              ? provider.entries
              : provider.entries.where((entry) {
                  final formattedDate = DateFormat('yyyy-MM-dd').format(entry.date);
                  return formattedDate == DateFormat('yyyy-MM-dd').format(_selectedDate!);
                }).toList();

          if (filteredEntries.isEmpty) {
            return Center(child: Text('No diary entries available.'));
          }

          return ListView.builder(
            itemCount: filteredEntries.length,
            itemBuilder: (context, index) {
              return EntryCard(
                entry: filteredEntries[index],
                onDelete: () {
                  final entryId = filteredEntries[index].id;
                  if (entryId != null) {
                    provider.deleteEntryLocally(entryId);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Entry deleted successfully')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: Entry ID is null')),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

// Custom date picker dialog with search bar functionality
class CustomDatePickerDialog extends StatefulWidget {
  final DateTime currentDate;

  CustomDatePickerDialog({required this.currentDate});

  @override
  _CustomDatePickerDialogState createState() => _CustomDatePickerDialogState();
}

class _CustomDatePickerDialogState extends State<CustomDatePickerDialog> {
  TextEditingController _searchController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.currentDate;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Pick a Date"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(hintText: "Search for a date (e.g., 2024-11-12)"),
            onChanged: (query) {
              // You can implement filtering logic here
            },
          ),
          SizedBox(height: 10),
          Container(
            width: double.infinity,
            height: 200,
            child: CalendarDatePicker(
              initialDate: _selectedDate,
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
              onDateChanged: (date) {
                setState(() {
                  _selectedDate = date;
                });
              },
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(_selectedDate);
          },
          child: Text('Confirm'),
        ),
      ],
    );
  }
}
