import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _currentTheme;
  bool _isDarkMode;

  // Constructor does not need an initial theme parameter
  ThemeProvider()
      : _isDarkMode = false,
        _currentTheme = ThemeData.light() {
    _loadTheme(); // Load the theme preference when the provider is initialized
  }

  ThemeData get currentTheme => _currentTheme;
  bool get isDarkMode => _isDarkMode;

  // Load the theme preference from SharedPreferences
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false; // Default to false if no value
    _currentTheme = _isDarkMode ? ThemeData.dark() : ThemeData.light();
    notifyListeners(); // Notify listeners after loading the theme
  }

  // Save the theme preference to SharedPreferences
  Future<void> _saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', _isDarkMode); // Save the theme state (dark or light)
  }

  // Toggle between dark and light theme
  void toggleTheme() {
    _isDarkMode = !_isDarkMode; // Toggle the dark mode flag
    _currentTheme = _isDarkMode ? ThemeData.dark() : ThemeData.light(); // Apply the theme based on the flag
    _saveTheme(); // Save the updated theme preference
    notifyListeners(); // Notify listeners to update the UI
  }

  // Allows for setting a custom theme
  void setTheme(ThemeData theme) {
    _currentTheme = theme; // Set the custom theme
    notifyListeners(); // Notify listeners to update the UI
  }
}
