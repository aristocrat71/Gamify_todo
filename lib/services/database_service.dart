import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import '../models/task.dart';
import '../models/day_log.dart';

class DatabaseService {
  DatabaseService._();
  static final DatabaseService instance = DatabaseService._();

  Database? _db;

  Future<Database> get database async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'gamify_todo.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tasks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            difficulty TEXT NOT NULL,
            is_completed INTEGER DEFAULT 0,
            created_at TEXT NOT NULL,
            completed_at TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE day_logs (
            date TEXT PRIMARY KEY,
            tasks_added INTEGER NOT NULL,
            tasks_completed INTEGER NOT NULL,
            xp_earned INTEGER NOT NULL,
            xp_lost INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  // --- Task CRUD ---

  Future<int> insertTask(Task task) async {
    final db = await database;
    return db.insert('tasks', task.toMap());
  }

  Future<void> updateTask(Task task) async {
    final db = await database;
    await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> deleteTask(int id) async {
    final db = await database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<Task?> getTaskById(int id) async {
    final db = await database;
    final maps = await db.query('tasks', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return Task.fromMap(maps.first);
  }

  Future<List<Task>> getTasksByDate(String date) async {
    final db = await database;
    final maps = await db.query(
      'tasks',
      where: 'created_at = ?',
      whereArgs: [date],
    );
    return maps.map(Task.fromMap).toList();
  }

  Future<int> getTotalCompletedTasks() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM tasks WHERE is_completed = 1',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> getCompletedHardTasks() async {
    final db = await database;
    final result = await db.rawQuery(
      "SELECT COUNT(*) as count FROM tasks WHERE is_completed = 1 AND difficulty = 'hard'",
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // --- DayLog CRUD ---

  Future<void> insertDayLog(DayLog log) async {
    final db = await database;
    await db.insert('day_logs', log.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<DayLog?> getDayLog(String date) async {
    final db = await database;
    final maps = await db.query('day_logs', where: 'date = ?', whereArgs: [date]);
    if (maps.isEmpty) return null;
    return DayLog.fromMap(maps.first);
  }

  Future<List<DayLog>> getLastNDaysLogs(int n) async {
    final db = await database;
    final maps = await db.query(
      'day_logs',
      orderBy: 'date DESC',
      limit: n,
    );
    return maps.map(DayLog.fromMap).toList().reversed.toList();
  }

  // --- Reset ---

  Future<void> deleteAllData() async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('tasks');
      await txn.delete('day_logs');
    });
  }
}
