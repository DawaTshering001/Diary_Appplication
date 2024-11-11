import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthenticationScreen extends StatefulWidget {
  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> with SingleTickerProviderStateMixin {
  final LocalAuthentication auth = LocalAuthentication();
  final FlutterSecureStorage storage = FlutterSecureStorage();
  String? _pin;
  bool _isFirstSetup = false;
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();
    _checkForPin();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeInAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Check if the PIN or biometric setup exists
  Future<void> _checkForPin() async {
    _pin = await storage.read(key: 'diary_pin');
    if (_pin == null) {
      setState(() {
        _isFirstSetup = true;
      });
    } else {
      _authenticate();
    }
  }

  // Setup PIN for first-time users
  Future<void> _setupPin() async {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController pinController = TextEditingController();
        return AlertDialog(
          title: Text("Set up your PIN"),
          content: TextField(
            controller: pinController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: "Create a 4-digit PIN",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                if (pinController.text.length == 4) {
                  await storage.write(key: 'diary_pin', value: pinController.text);
                  setState(() {
                    _isFirstSetup = false;
                    _pin = pinController.text;
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('PIN set successfully!')),
                  );
                  _authenticate();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('PIN must be 4 digits')),
                  );
                }
              },
              child: Text("Set PIN"),
            ),
          ],
        );
      },
    );
  }

  // Attempt biometric authentication or fall back to PIN
  Future<void> _authenticate() async {
    bool authenticated = false;

    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Authenticate to access your diary',
        options: const AuthenticationOptions(biometricOnly: true),
      );
      if (authenticated) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        _enterPin();
      }
    } catch (e) {
      print("Error with authentication: $e");
      _enterPin();
    }
  }

  // Show PIN input dialog
  void _enterPin() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController pinController = TextEditingController();
        return AlertDialog(
          title: Text("Enter PIN"),
          content: TextField(
            controller: pinController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: "Enter your PIN",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (pinController.text == _pin) {
                  Navigator.pushReplacementNamed(context, '/home');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Invalid PIN')),
                  );
                }
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade700, Colors.grey.shade700],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeInAnimation,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Welcome to Diary App",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Secure your diary with a PIN or biometric authentication.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
                  ),
                  SizedBox(height: 40),
                  if (_isFirstSetup) ...[
                    ElevatedButton.icon(
                      onPressed: _setupPin,
                      icon: Icon(Icons.lock, color: Colors.white),
                      label: Text("Set Up PIN"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _authenticate,
                      icon: Icon(Icons.fingerprint, color: Colors.white),
                      label: Text("Enable Biometric Login"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ] else ...[
                    ElevatedButton.icon(
                      onPressed: _authenticate,
                      icon: Icon(Icons.fingerprint, color: Colors.white),
                      label: Text("Login with Biometrics"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _enterPin,
                      icon: Icon(Icons.lock, color: Colors.white),
                      label: Text("Login with PIN"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/forgot-password');
                      },
                      child: Text(
                        "Forgot PIN?",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
