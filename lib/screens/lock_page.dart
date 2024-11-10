import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LockPage extends StatelessWidget {
  final LocalAuthentication auth = LocalAuthentication();
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lock Your Diary'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 80,
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.security, size: 100, color: Colors.white),
              ),
              SizedBox(height: 20),
              Text(
                'Secure Your Diary',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              _buildLockButton(
                context,
                icon: Icons.fingerprint,
                label: 'Set up Biometric Lock',
                onPressed: () async {
                  try {
                    bool authenticated = await _authenticateBiometrics();
                    if (authenticated) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Biometric lock enabled')),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                },
              ),
              SizedBox(height: 15),
              _buildLockButton(
                context,
                icon: Icons.lock,
                label: 'Set up PIN Lock',
                onPressed: () async {
                  try {
                    await _setupPin(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                },
              ),
              SizedBox(height: 15),
              _buildLockButton(
                context,
                icon: Icons.pattern,
                label: 'Set up Pattern Lock',
                onPressed: () {
                  _setupPattern(context);
                },
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  bool authenticated = await _authenticateWithLock(context);
                  if (authenticated) {
                    // Proceed to Diary page or main content
                    Navigator.pushReplacementNamed(context, '/diary');
                  }
                },
                child: Text('Login to Diary'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLockButton(BuildContext context, {required IconData icon, required String label, required Function() onPressed}) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 30),
      label: Text(
        label,
        style: TextStyle(fontSize: 18),
      ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        minimumSize: Size(double.infinity, 60),
      ),
      onPressed: onPressed,
    );
  }

  Future<bool> _authenticateBiometrics() async {
    try {
      bool canAuthenticate = await auth.canCheckBiometrics;
      if (canAuthenticate) {
        return await auth.authenticate(
          localizedReason: 'Please authenticate to enable biometric lock',
          options: AuthenticationOptions(biometricOnly: true),
        );
      }
      return false;
    } catch (e) {
      print("Biometric authentication error: $e");
      return false;
    }
  }

  Future<void> _setupPin(BuildContext context) async {
    TextEditingController pinController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Set PIN"),
          content: TextField(
            controller: pinController,
            keyboardType: TextInputType.number,
            maxLength: 4,
            obscureText: true,
            decoration: InputDecoration(labelText: "Enter 4-digit PIN"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text("Save"),
              onPressed: () async {
                if (pinController.text.length == 4) {
                  try {
                    await secureStorage.write(key: 'diary_pin', value: pinController.text);
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('PIN lock enabled')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a 4-digit PIN')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _setupPattern(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Pattern lock setup feature coming soon')),
    );
  }

  Future<bool> _authenticateWithLock(BuildContext context) async {
    bool authenticated = false;

    // First try biometric authentication
    authenticated = await _authenticateBiometrics();

    if (!authenticated) {
      // If biometrics fail, fall back to PIN authentication
      String? storedPin = await secureStorage.read(key: 'diary_pin');
      String enteredPin = await _showPinDialog(context);

      if (storedPin != null && storedPin == enteredPin) {
        authenticated = true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid PIN')),
        );
      }
    }

    return authenticated;
  }

  Future<String> _showPinDialog(BuildContext context) async {
    TextEditingController pinController = TextEditingController();
    String enteredPin = '';

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Enter PIN"),
          content: TextField(
            controller: pinController,
            keyboardType: TextInputType.number,
            maxLength: 4,
            obscureText: true,
            decoration: InputDecoration(labelText: "Enter PIN"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text("Submit"),
              onPressed: () {
                enteredPin = pinController.text;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

    return enteredPin;
  }
}
