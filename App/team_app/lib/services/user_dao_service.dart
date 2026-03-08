import 'package:sqflite/sqflite.dart';
import 'database_service.dart';

class UserDao {
  Future<void> insertUser(String email, String password) async {
    final db = await DatabaseHelper.instance.database;
    await db.insert(
      'users',
      {'email': email, 'password': password},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<bool> checkLogin(String email, String password) async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return result.isNotEmpty;
  }
}
