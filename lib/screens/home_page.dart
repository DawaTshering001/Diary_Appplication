import 'package:flutter/material.dart';
import 'package:flutter_application/screens/lock_page.dart';
import 'package:intl/intl.dart'; // Import intl for date formatting
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
  final TextEditingController _searchController = TextEditingController();
  String _searchDate = '';

  // Add a GlobalKey for the Scaffold
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // Load the diary entries when the app is opened
    _loadEntries();
  }

  // Function to load entries (could be from a local database or API)
  void _loadEntries() {
    Provider.of<EntryProvider>(context, listen: false).fetchEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Set the GlobalKey to the Scaffold
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
            // Open the drawer using the GlobalKey
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by date (e.g., YYYY-MM-DD)',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      _searchDate = _searchController.text.trim();
                    });
                  },
                ),
              ),
              onSubmitted: (value) {
                setState(() {
                  _searchDate = value.trim();
                });
              },
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
                color: Colors.grey, // Customize header color
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
          // Filter entries based on search date
          final filteredEntries = _searchDate.isEmpty
              ? provider.entries
              : provider.entries.where((entry) {
                  final formattedDate = DateFormat('yyyy-MM-dd').format(entry.date);
                  return formattedDate.contains(_searchDate);
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
