import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';  // Ensure this imports your ThemeProvider
import 'screens/home_page.dart';
import 'screens/authentication_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'providers/entry_provider.dart';
import 'theme/app_theme.dart'; // Import your theme definitions

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => EntryProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()), // Add ThemeProvider here
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Diary App',
            theme: themeProvider.currentTheme, // Use the current theme from ThemeProvider
            home: AuthenticationScreen(), // Home screen or Authentication screen
            routes: {
              '/home': (context) => HomePage(),
              '/forgot-password': (context) => ForgotPasswordScreen(),
            },
          );
        },
      ),
    );
  }
}
