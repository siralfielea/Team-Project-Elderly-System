
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT UNIQUE,
            password TEXT
          );
          CREATE TABLE devices (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  device_id TEXT UNIQUE,        -- stable device identifier (from Pi)
  user_id INTEGER,              -- nullable until paired
  label TEXT,                   -- e.g. "Wrist unit", optional
  paired_at INTEGER,            -- unix timestamp
  last_seen INTEGER,            -- unix timestamp
  status TEXT,                  -- e.g. "paired", "unpaired", "lost"
  FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE SET NULL
);
        ''');
      },
    );
  }
}
