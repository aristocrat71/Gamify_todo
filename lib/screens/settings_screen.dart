import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../providers/xp_provider.dart';
import '../providers/achievement_provider.dart';
import '../services/database_service.dart';
import '../services/prefs_service.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _resetData(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: const Text('Reset All Data?'),
        content: const Text(
          'This will delete all tasks, stats, and achievements. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await DatabaseService.instance.deleteAllData();
              await PrefsService.instance.clearAll();
              await PrefsService.instance.init();

              if (context.mounted) {
                context.read<XpProvider>().loadFromPrefs();
                context.read<AchievementProvider>().loadFromPrefs();
                context.read<TaskProvider>().loadTodayTasks();
              }

              if (ctx.mounted) Navigator.pop(ctx);

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All data has been reset.')),
                );
              }
            },
            child: const Text('Reset', style: TextStyle(color: AppTheme.penaltyRed)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.delete_forever, color: AppTheme.penaltyRed),
              title: const Text('Reset All Data'),
              subtitle: const Text('Delete tasks, XP, streaks, and achievements'),
              onTap: () => _resetData(context),
            ),
          ),
          const SizedBox(height: 32),
          const Center(
            child: Text(
              'Gamify Todo v1.0.0',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
