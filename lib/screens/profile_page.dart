import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue,
              child: Icon(Icons.account_circle, size: 80, color: Colors.white),
            ),
            SizedBox(height: 20),
            Text('User Name', style: TextStyle(fontSize: 24)),
            SizedBox(height: 10),
            Text('Email: user@example.com', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
