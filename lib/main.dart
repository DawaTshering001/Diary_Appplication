import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_page.dart';
import 'screens/authentication_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'providers/entry_provider.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EntryProvider(),
      child: MaterialApp(
        title: 'Diary App',
        theme: lightTheme, // Use the theme from app_theme.dart
        home: AuthenticationScreen(), // Start with the authentication screen
        routes: {
          '/home': (context) => HomePage(),
          '/forgot-password': (context) => ForgotPasswordScreen(),
        },
      ),
    );
  }
}