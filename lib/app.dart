import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/add_task_screen.dart';
import 'screens/stats_screen.dart';
import 'screens/achievements_screen.dart';
import 'screens/settings_screen.dart';

class GamifyTodoApp extends StatelessWidget {
  const GamifyTodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gamify Todo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: '/',
      routes: {
        '/': (_) => const HomeScreen(),
        '/add-task': (_) => const AddTaskScreen(),
        '/stats': (_) => const StatsScreen(),
        '/achievements': (_) => const AchievementsScreen(),
        '/settings': (_) => const SettingsScreen(),
      },
    );
  }
}
