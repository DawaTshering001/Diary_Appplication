// forgot_password_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final FlutterSecureStorage storage = FlutterSecureStorage();
  TextEditingController _newPinController = TextEditingController();

  // Reset the PIN to a new value
  Future<void> _resetPin() async {
    String newPin = _newPinController.text.trim();
    if (newPin.isNotEmpty) {
      await storage.write(key: 'diary_pin', value: newPin);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PIN reset successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Reset PIN")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _newPinController,
              obscureText: true,
              decoration: InputDecoration(hintText: "Enter new PIN"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resetPin,
              child: Text("Reset PIN"),
            ),
          ],
        ),
      ),
    );
  }
}
