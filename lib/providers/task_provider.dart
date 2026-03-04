import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../services/database_service.dart';

class TaskProvider extends ChangeNotifier {
  final DatabaseService _db;

  TaskProvider(this._db);

  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  String get _today => DateFormat('yyyy-MM-dd').format(DateTime.now());

  Future<void> loadTodayTasks() async {
    _tasks = await _db.getTasksByDate(_today);
    notifyListeners();
  }

  static const validDifficulties = ['easy', 'medium', 'hard'];

  Future<Task> addTask({
    required String title,
    required String difficulty,
  }) async {
    if (!validDifficulties.contains(difficulty)) {
      throw ArgumentError('Invalid difficulty: $difficulty');
    }
    final task = Task(
      title: title,
      difficulty: difficulty,
      createdAt: _today,
    );
    final id = await _db.insertTask(task);
    final saved = task.copyWith(id: id);
    _tasks.add(saved);
    notifyListeners();
    return saved;
  }

  /// Marks a task complete. Returns the task so callers can calculate XP.
  Future<Task> toggleComplete(int taskId) async {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index == -1) throw Exception('Task not found');

    final task = _tasks[index];
    final now = DateTime.now().toIso8601String();
    final updated = task.copyWith(
      isCompleted: !task.isCompleted,
      completedAt: !task.isCompleted ? now : null,
    );

    await _db.updateTask(updated);
    _tasks[index] = updated;
    notifyListeners();
    return updated;
  }

  Future<void> deleteTask(int taskId) async {
    await _db.deleteTask(taskId);
    _tasks.removeWhere((t) => t.id == taskId);
    notifyListeners();
  }

  int get completedCount => _tasks.where((t) => t.isCompleted).length;
  int get totalCount => _tasks.length;
  bool get allCompleted => _tasks.isNotEmpty && completedCount == totalCount;
}
