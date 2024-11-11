import 'package:flutter/material.dart';
import '../models/diary_entry.dart';
import '../services/database_service.dart';

class EntryProvider with ChangeNotifier {
  List<DiaryEntry> _entries = [];
  final DatabaseService _dbService = DatabaseService();

  List<DiaryEntry> get entries => _entries;

  // Fetch all entries from the database
  Future<void> fetchEntries() async {
    try {
      _entries = await _dbService.fetchEntries();
      notifyListeners();
    } catch (e) {
      // Handle error (maybe show a message to the user)
      print('Error fetching entries: $e');
    }
  }

  // Add a new entry to the database
  Future<void> addEntry(DiaryEntry entry) async {
    try {
      await _dbService.insertEntry(entry);
      // Instead of refetching all entries, you can add it locally to the list
      _entries.insert(0, entry);  // Add to the top of the list (most recent entry)
      notifyListeners();
    } catch (e) {
      // Handle error
      print('Error adding entry: $e');
    }
  }

  // Delete an entry (fetches from DB after delete)
  Future<void> deleteEntry(int id) async {
    try {
      await _dbService.deleteEntry(id);
      // Remove from the local list as well
      _entries.removeWhere((entry) => entry.id == id);
      notifyListeners();
    } catch (e) {
      // Handle error
      print('Error deleting entry: $e');
    }
  }

  // Alternatively, delete entry locally (without refetching)
  Future<void> deleteEntryLocally(int id) async {
    try {
      // Remove the entry from the local list first
      _entries.removeWhere((entry) => entry.id == id);
      notifyListeners();

      // Then delete it from the database
      await _dbService.deleteEntry(id);
    } catch (e) {
      // Handle error
      print('Error deleting entry locally: $e');
    }
  }
}
