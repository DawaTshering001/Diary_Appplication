import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: SingleChildScrollView( // Wrap Column in SingleChildScrollView
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              'Welcome to Your Personal Diary App!',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.book, size: 60, color: Colors.white),
            ),
            SizedBox(height: 20),
            Text(
              'Our Mission',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 10),
            Text(
              'This app was built to help you capture memories, reflect on experiences, and cultivate a habit of personal reflection. We believe everyone deserves a safe, private, and beautiful space to document their journey.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            Text(
              'Features',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 10),
            FeatureItem(
              icon: Icons.lock,
              title: 'Security',
              description: 'Protect your entries with PIN, biometrics, or pattern lock to keep your thoughts safe and private.',
            ),
            FeatureItem(
              icon: Icons.palette,
              title: 'Customization',
              description: 'Personalize your diary with themes, allowing you to select colors and styles that match your mood.',
            ),
            FeatureItem(
              icon: Icons.notifications,
              title: 'Reminders',
              description: 'Set reminders to make journaling a daily habit and never miss a chance to record important moments.',
            ),
            FeatureItem(
              icon: Icons.cloud,
              title: 'Backup & Restore',
              description: 'Securely back up your entries to the cloud, ensuring they’re safe and accessible anytime.',
            ),
            SizedBox(height: 20),
            Text(
              'We are committed to helping you write the story of your life, one day at a time.',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  FeatureItem({required this.icon, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blueAccent, size: 28),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
