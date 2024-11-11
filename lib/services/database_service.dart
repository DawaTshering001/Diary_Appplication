import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/diary_entry.dart';

class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'diary.db');
    return await openDatabase(
      path,
      version: 3, // Updated version to 3
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE entries(id INTEGER PRIMARY KEY, title TEXT, content TEXT, date TEXT, mood TEXT, imagePath TEXT, image BLOB)',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE entries ADD COLUMN mood TEXT');
        }
        if (oldVersion < 3) {
          await db.execute('ALTER TABLE entries ADD COLUMN imagePath TEXT');
          await db.execute('ALTER TABLE entries ADD COLUMN image BLOB');
        }
      },
    );
  }
Future<DiaryEntry?> insertEntry(DiaryEntry entry) async {
  final db = await database;
  try {
    // Perform the insert operation and capture the generated ID
    final id = await db.insert(
      'entries',
      entry.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Return the updated entry with the assigned id
    return entry.copyWith(id: id);  // Ensure the entry gets its id
  } catch (e) {
    print('Error adding entry: $e');
    return null; // Return null if there was an error
  }
}



  Future<List<DiaryEntry>> fetchEntries() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('entries', orderBy: 'date DESC');
    return List.generate(maps.length, (i) {
      return DiaryEntry.fromMap(maps[i]);
    });
  }

  Future<void> updateEntry(DiaryEntry entry) async {
    final db = await database;
    await db.update(
      'entries',
      entry.toMap(),
      where: 'id = ?',
      whereArgs: [entry.id],
    );
  }

  Future<void> deleteEntry(int id) async {
    final db = await database;
    await db.delete(
      'entries',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> closeDB() async {
    final db = await database;
    db.close();
  }
}
