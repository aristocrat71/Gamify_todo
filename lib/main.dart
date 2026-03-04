import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'services/database_service.dart';
import 'services/prefs_service.dart';
import 'providers/task_provider.dart';
import 'providers/xp_provider.dart';
import 'providers/achievement_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  final db = DatabaseService.instance;
  await db.database; // ensure DB is created
  final prefs = PrefsService.instance;
  await prefs.init();

  // Create providers
  final xpProvider = XpProvider(db, prefs);
  xpProvider.loadFromPrefs();

  final achievementProvider = AchievementProvider(db, prefs);
  achievementProvider.loadFromPrefs();

  // Run day-transition before rendering
  await xpProvider.runDayTransition();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider(db)),
        ChangeNotifierProvider.value(value: xpProvider),
        ChangeNotifierProvider.value(value: achievementProvider),
      ],
      child: const GamifyTodoApp(),
    ),
  );
}
