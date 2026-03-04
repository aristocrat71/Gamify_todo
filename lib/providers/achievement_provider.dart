import 'package:flutter/foundation.dart';
import '../services/database_service.dart';
import '../services/prefs_service.dart';
import '../utils/constants.dart';

class AchievementProvider extends ChangeNotifier {
  final DatabaseService _db;
  final PrefsService _prefs;

  AchievementProvider(this._db, this._prefs);

  Set<String> _unlocked = {};
  Set<String> get unlocked => _unlocked;

  void loadFromPrefs() {
    _unlocked = _prefs.achievements.toSet();
    notifyListeners();
  }

  /// Run all achievement checks. Call after task completion and day-transition.
  Future<List<String>> checkAndUnlock({
    required int level,
    required int currentStreak,
    required int completedToday,
    required int totalToday,
  }) async {
    final newlyUnlocked = <String>[];

    final totalCompleted = await _db.getTotalCompletedTasks();
    final hardCompleted = await _db.getCompletedHardTasks();

    final validIds = achievementDefs.map((a) => a.id).toSet();

    void check(String id, bool condition) {
      assert(validIds.contains(id), 'Unknown achievement ID: $id');
      if (!_unlocked.contains(id) && condition) {
        _unlocked.add(id);
        newlyUnlocked.add(id);
      }
    }

    check('first_blood', totalCompleted >= 1);
    check('hat_trick', completedToday >= 3);
    check('perfect_day', totalToday > 0 && completedToday == totalToday);
    check('on_fire', currentStreak >= 7);
    check('unstoppable', currentStreak >= 30);
    check('level_5', level >= 5);
    check('level_10', level >= 10);
    check('level_25', level >= 25);
    check('centurion', totalCompleted >= 100);
    check('hard_worker', hardCompleted >= 10);

    if (newlyUnlocked.isNotEmpty) {
      _prefs.achievements = _unlocked.toList();
      notifyListeners();
    }

    return newlyUnlocked;
  }

  bool isUnlocked(String id) => _unlocked.contains(id);
}
