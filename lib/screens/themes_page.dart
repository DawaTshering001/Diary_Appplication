import 'package:flutter/material.dart';

class ThemesPage extends StatefulWidget {
  @override
  _ThemesPageState createState() => _ThemesPageState();
}

class _ThemesPageState extends State<ThemesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Themes'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Choose your theme', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Apply theme
              },
              child: Text('Apply Dark Theme'),
            ),
            ElevatedButton(
              onPressed: () {
                // Apply theme
              },
              child: Text('Apply Light Theme'),
            ),
          ],
        ),
      ),
    );
  }
}
