import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          // Language settings
          ListTile(
            title: Text('Language'),
            trailing: Icon(Icons.language),
            onTap: () {
              // Language change functionality
            },
          ),
          
          // Notifications settings
          ListTile(
            title: Text('Notifications'),
            trailing: Icon(Icons.notifications),
            onTap: () {
              // Notifications settings functionality
            },
          ),
          
          // Theme (Light/Dark Mode) settings
          ListTile(
            title: Text('Theme'),
            trailing: Icon(Icons.brightness_6),
            onTap: () {
              // Toggle between Light and Dark mode
              _toggleTheme(context);
            },
          ),
          
          // Account management
          ListTile(
            title: Text('Account'),
            trailing: Icon(Icons.account_circle),
            onTap: () {
              // Account settings functionality (e.g., logout, change password)
            },
          ),
          
          // Privacy settings
          ListTile(
            title: Text('Privacy'),
            trailing: Icon(Icons.lock),
            onTap: () {
              // Privacy settings functionality
            },
          ),
          
          // Help & Support
          ListTile(
            title: Text('Help & Support'),
            trailing: Icon(Icons.help),
            onTap: () {
              // Open Help & Support page
            },
          ),
          
          // About the App
          ListTile(
            title: Text('About'),
            trailing: Icon(Icons.info),
            onTap: () {
              // Show app version, developer info, etc.
              _showAboutDialog(context);
            },
          ),
          
          // Logout button
          ListTile(
            title: Text('Logout'),
            trailing: Icon(Icons.exit_to_app),
            onTap: () {
              // Logout functionality
              _logout(context);
            },
          ),
        ],
      ),
    );
  }

  // Toggle between light and dark themes (dummy implementation)
  void _toggleTheme(BuildContext context) {
    // Toggle theme (you may use a theme provider to persist this setting)
    final theme = Theme.of(context).brightness == Brightness.dark
        ? ThemeData.light()
        : ThemeData.dark();
    // Update theme (consider using a state management solution to handle theme changes)
    // For now, it can just rebuild the widget tree with the updated theme
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SettingsPage()),
    );
  }

  // Show about dialog
  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AboutDialog(
          applicationName: 'Diary App',
          applicationVersion: '1.0.0',
          applicationIcon: Icon(Icons.book),
          children: [
            Text('This is a simple diary app developed to help you record your thoughts.'),
            SizedBox(height: 10),
            Text('Developed by: Your Name'),
          ],
        );
      },
    );
  }

  // Logout functionality (dummy implementation)
  void _logout(BuildContext context) {
    // Clear user session and redirect to login page (implement your logic)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('You have logged out successfully')),
    );
    // Navigate back to login page or splash screen
  }
}
