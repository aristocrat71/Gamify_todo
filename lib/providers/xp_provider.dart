import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../models/day_log.dart';
import '../services/database_service.dart';
import '../services/prefs_service.dart';
import '../utils/xp_calculator.dart';

class XpProvider extends ChangeNotifier {
  final DatabaseService _db;
  final PrefsService _prefs;

  XpProvider(this._db, this._prefs);

  int _level = 1;
  int _totalXp = 0;
  int _xpInCurrentLevel = 0;
  int _currentStreak = 0;
  int _bestStreak = 0;

  int get level => _level;
  int get totalXp => _totalXp;
  int get xpInCurrentLevel => _xpInCurrentLevel;
  int get currentStreak => _currentStreak;
  int get bestStreak => _bestStreak;
  int get xpNeeded => xpForNextLevel(_level);

  void loadFromPrefs() {
    _level = _prefs.level;
    _totalXp = _prefs.totalXp;
    _xpInCurrentLevel = _prefs.xpInCurrentLevel;
    _currentStreak = _prefs.currentStreak;
    _bestStreak = _prefs.bestStreak;
    notifyListeners();
  }

  /// Add XP, handling multi-level-ups in a loop.
  void addXp(int amount) {
    _totalXp += amount;
    _xpInCurrentLevel += amount;

    // Check for level-ups
    while (_xpInCurrentLevel >= xpForNextLevel(_level)) {
      _xpInCurrentLevel -= xpForNextLevel(_level);
      _level++;
    }

    _save();
    notifyListeners();
  }

  /// Remove XP. Clamps xpInCurrentLevel to 0 — no de-leveling.
  void removeXp(int amount) {
    _totalXp = (_totalXp - amount).clamp(0, _totalXp);
    _xpInCurrentLevel = (_xpInCurrentLevel - amount).clamp(0, _xpInCurrentLevel);

    _save();
    notifyListeners();
  }

  /// Run day-transition logic. Call on every app open before rendering home.
  Future<void> runDayTransition() async {
    final lastDate = _prefs.lastActiveDate;
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    if (lastDate == null) {
      // First ever launch
      _prefs.lastActiveDate = today;
      return;
    }

    if (lastDate == today) {
      // Same day, nothing to do
      return;
    }

    // Date has changed — process last active date's tasks
    final allTasks = await _db.getTasksByDate(lastDate);

    if (allTasks.isEmpty) {
      // No tasks were set that day, streak continues passively
      // But check for multi-day gap
      final daysSince = _daysBetween(lastDate, today);
      if (daysSince > 1) {
        _currentStreak = 0;
      }
      _prefs.lastActiveDate = today;
      _save();
      notifyListeners();
      return;
    }

    final completed = allTasks.where((t) => t.isCompleted).toList();
    final incomplete = allTasks.where((t) => !t.isCompleted).toList();

    int xpEarned = 0;
    int xpLost = 0;

    final multiplier = getStreakMultiplier(_currentStreak);
    for (final task in completed) {
      xpEarned += (calculateReward(task.difficulty) * multiplier).round();
    }
    for (final task in incomplete) {
      xpLost += calculatePenalty(task.difficulty);
    }

    // Apply XP
    if (xpEarned > 0) addXp(xpEarned);
    if (xpLost > 0) removeXp(xpLost);

    // Update streak
    if (incomplete.isEmpty) {
      _currentStreak++;
      if (_currentStreak > _bestStreak) _bestStreak = _currentStreak;
    } else {
      _currentStreak = 0;
    }

    // Write day log
    await _db.insertDayLog(DayLog(
      date: lastDate,
      tasksAdded: allTasks.length,
      tasksCompleted: completed.length,
      xpEarned: xpEarned,
      xpLost: xpLost,
    ));

    // Multi-day gap resets streak
    final daysSince = _daysBetween(lastDate, today);
    if (daysSince > 1) {
      _currentStreak = 0;
    }

    _prefs.lastActiveDate = today;
    _save();
    notifyListeners();
  }

  void _save() {
    _prefs.saveAll(
      level: _level,
      totalXp: _totalXp,
      xpInCurrentLevel: _xpInCurrentLevel,
      currentStreak: _currentStreak,
      bestStreak: _bestStreak,
    );
  }

  int _daysBetween(String from, String to) {
    final d1 = DateTime.parse(from);
    final d2 = DateTime.parse(to);
    return d2.difference(d1).inDays;
  }
}
