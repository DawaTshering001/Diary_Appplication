import 'package:flutter/material.dart';
import '../models/diary_entry.dart';
import '../services/database_service.dart';

class EntryProvider with ChangeNotifier {
  List<DiaryEntry> _entries = [];
  final DatabaseService _dbService = DatabaseService();

  List<DiaryEntry> get entries => _entries;

  // Fetch all entries from the database
  Future<void> fetchEntries() async {
    _entries = await _dbService.fetchEntries();
    notifyListeners();
  }

  // Add a new entry to the database
  Future<void> addEntry(DiaryEntry entry) async {
    await _dbService.insertEntry(entry);
    await fetchEntries();
  }

  // Delete an entry (fetches from DB after delete)
  Future<void> deleteEntry(int id) async {
    await _dbService.deleteEntry(id);
    await fetchEntries();
  }

  // Alternatively, delete entry locally (without refetching)
  Future<void> deleteEntryLocally(int id) async {
    // Delete the entry from the database
    await _dbService.deleteEntry(id);

    // Remove the entry from the in-memory list
    _entries.removeWhere((entry) => entry.id == id);

    // Notify listeners to rebuild the UI
    notifyListeners();
  }
}
