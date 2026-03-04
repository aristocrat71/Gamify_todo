import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  PrefsService._();
  static final PrefsService instance = PrefsService._();

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // --- Level & XP ---

  int get level => _prefs.getInt('level') ?? 1;
  set level(int v) => _prefs.setInt('level', v);

  int get totalXp => _prefs.getInt('total_xp') ?? 0;
  set totalXp(int v) => _prefs.setInt('total_xp', v);

  int get xpInCurrentLevel => _prefs.getInt('xp_in_current_level') ?? 0;
  set xpInCurrentLevel(int v) => _prefs.setInt('xp_in_current_level', v);

  // --- Streak ---

  int get currentStreak => _prefs.getInt('current_streak') ?? 0;
  set currentStreak(int v) => _prefs.setInt('current_streak', v);

  int get bestStreak => _prefs.getInt('best_streak') ?? 0;
  set bestStreak(int v) => _prefs.setInt('best_streak', v);

  // --- Last Active Date ---

  String? get lastActiveDate => _prefs.getString('last_active_date');
  set lastActiveDate(String? v) {
    if (v != null) _prefs.setString('last_active_date', v);
  }

  // --- Achievements ---

  List<String> get achievements {
    final raw = _prefs.getString('achievements');
    if (raw == null) return [];
    return List<String>.from(jsonDecode(raw));
  }

  set achievements(List<String> ids) {
    _prefs.setString('achievements', jsonEncode(ids));
  }

  // --- Bulk save ---

  void saveAll({
    required int level,
    required int totalXp,
    required int xpInCurrentLevel,
    required int currentStreak,
    required int bestStreak,
  }) {
    this.level = level;
    this.totalXp = totalXp;
    this.xpInCurrentLevel = xpInCurrentLevel;
    this.currentStreak = currentStreak;
    this.bestStreak = bestStreak;
  }

  // --- Reset ---

  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
