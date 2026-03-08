
import 'package:sqflite/sqflite.dart';
import 'database_service.dart';

class DeviceDao {
  Future<int> insertDevice(String deviceId, {String? label}) async {
    final db = await DatabaseHelper.instance.database;
    return await db.insert(
      'devices',
      {
        'device_id': deviceId,
        'label': label,
        'status': 'unpaired',
        'last_seen': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore, // keep existing if duplicate
    );
  }

  Future<bool> pairDeviceToUser(String deviceId, int userId) async {
    final db = await DatabaseHelper.instance.database;
    final res = await db.update(
      'devices',
      {
        'user_id': userId,
        'paired_at': DateTime.now().millisecondsSinceEpoch,
        'status': 'paired',
      },
      where: 'device_id = ?',
      whereArgs: [deviceId],
    );
    return res > 0;
  }

  Future<Map<String, dynamic>?> getDeviceByDeviceId(String deviceId) async {
    final db = await DatabaseHelper.instance.database;
    final rows = await db.query('devices', where: 'device_id = ?', whereArgs: [deviceId]);
    return rows.isNotEmpty ? rows.first : null;
  }

  Future<List<Map<String, dynamic>>> getDevicesForUser(int userId) async {
    final db = await DatabaseHelper.instance.database;
    return await db.query('devices', where: 'user_id = ?', whereArgs: [userId]);
  }

  Future<int> unpairDevice(String deviceId) async {
    final db = await DatabaseHelper.instance.database;
    return await db.update(
      'devices',
      {'user_id': null, 'status': 'unpaired'},
      where: 'device_id = ?',
      whereArgs: [deviceId],
    );
  }
}
