import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database? _database;

  DatabaseHelper._instance();

  Future<Database> get database async {
    if (_database == null) {
      _database = await _initDb();
    }
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'barbershop.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Create users table
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT NOT NULL,
            password TEXT NOT NULL,
            type TEXT NOT NULL
          )
        ''');

        // Create work_hours table
        await db.execute('''
          CREATE TABLE work_hours (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            hour TEXT NOT NULL,
            is_available INTEGER NOT NULL
          )
        ''');

        // Insert initial work hours (from 09:00 to 18:00, all available)
        await insertInitialWorkHours(db);
      },
    );
  }

  Future<void> insertInitialWorkHours(Database db) async {
    List<String> times = [
      '09:00', '10:00', '11:00', '12:00',
      '13:00', '14:00', '15:00', '16:00',
      '17:00', '18:00'
    ];

    for (String time in times) {
      await db.insert('work_hours', {'hour': time, 'is_available': 1});
    }
  }

  Future<List<Map<String, dynamic>>> getAvailableWorkHours() async {
    Database db = await instance.database;
    return await db.query('work_hours', where: 'is_available = ?', whereArgs: [1]);
  }

  Future<void> updateWorkHourAvailability(String hour, bool isAvailable) async {
    Database db = await instance.database;
    await db.update('work_hours', {'is_available': isAvailable ? 1 : 0}, where: 'hour = ?', whereArgs: [hour]);
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    Database db = await instance.database;
    return await db.query('users');
  }

  Future<bool> checkAvailableTimes(DateTime selectedDay) async {
    Database db = await instance.database;
    String formattedDate = '${selectedDay.year}-${selectedDay.month.toString().padLeft(2, '0')}-${selectedDay.day.toString().padLeft(2, '0')}';
    List<Map<String, dynamic>> result = await db.query('work_hours', where: 'hour LIKE ?', whereArgs: ['$formattedDate%']);
    return result.isNotEmpty;
  }

  Future<void> deleteAllUnavailableTimes() async {
    final db = await instance.database;
    await db.delete('work_hours', where: 'is_available = ?', whereArgs: [0]);
  }

  Future<void> insertUnavailableTime(String hour) async {
    final db = await instance.database;
    await db.insert('work_hours', {'hour': hour, 'is_available': 0});
  }

  Future<void> printScheduledTimes() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> scheduledTimes = await db.query('work_hours');
    print('Horários agendados:');
    for (final time in scheduledTimes) {
      print('${time['hour']} - ${time['is_available'] == 1 ? 'Disponível' : 'Indisponível'}');
    }
  }

  Future<List<String>> getAvailableTimes(DateTime selectedDate) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query(
      'work_hours',
      columns: ['hour'],
      where: 'is_available = ?',
      whereArgs: [1],
    );

    List<String> availableTimes = [];
    for (Map<String, dynamic> row in result) {
      availableTimes.add(row['hour']);
    }
    return availableTimes;
  }


Future<List<String>> getUnavailableTimes() async {
  final Database db = await instance.database;
  final List<Map<String, dynamic>> maps = await db.query('work_hours', where: 'is_available = ?', whereArgs: [0]);
  return List.generate(maps.length, (index) => maps[index]['hour']);
}


  Future<void> initDb() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'barbershop.db');
  _database = await openDatabase(
    path,
    version: 1,
    onCreate: (db, version) async {
      // Create users table
      await db.execute('''
        CREATE TABLE users (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          username TEXT NOT NULL,
          password TEXT NOT NULL,
          type TEXT NOT NULL
        )
      ''');

      // Create work_hours table
      await db.execute('''
        CREATE TABLE work_hours (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          hour TEXT NOT NULL,
          is_available INTEGER NOT NULL
        )
      ''');

      // Insert initial work hours (from 09:00 to 18:00, all available)
      await insertInitialWorkHours(db);
    },
  );
}











}
