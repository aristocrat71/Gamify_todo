import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../providers/xp_provider.dart';
import '../providers/achievement_provider.dart';
import '../utils/xp_calculator.dart';
import '../theme/app_theme.dart';
import '../widgets/xp_bar.dart';
import '../widgets/level_badge.dart';
import '../widgets/streak_badge.dart';
import '../widgets/task_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TaskProvider>().loadTodayTasks();
  }

  void _onTaskToggle(int taskId) async {
    final taskProvider = context.read<TaskProvider>();
    final xpProvider = context.read<XpProvider>();
    final achievementProvider = context.read<AchievementProvider>();

    final task = await taskProvider.toggleComplete(taskId);

    if (task.isCompleted) {
      final multiplier = getStreakMultiplier(xpProvider.currentStreak);
      final reward = (calculateReward(task.difficulty) * multiplier).round();
      xpProvider.addXp(reward);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('+$reward XP!'),
            duration: const Duration(seconds: 1),
            backgroundColor: AppTheme.successGreen.withValues(alpha: 0.9),
          ),
        );
      }
    } else {
      final penalty = calculatePenalty(task.difficulty);
      xpProvider.removeXp(penalty);
    }

    // Check achievements
    final newAchievements = await achievementProvider.checkAndUnlock(
      level: xpProvider.level,
      currentStreak: xpProvider.currentStreak,
      completedToday: taskProvider.completedCount,
      totalToday: taskProvider.totalCount,
    );

    if (mounted && newAchievements.isNotEmpty) {
      for (final id in newAchievements) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Achievement unlocked: $id'),
            backgroundColor: AppTheme.levelPurple.withValues(alpha: 0.9),
          ),
        );
      }
    }
  }

  void _onTaskDismissed(int taskId) {
    context.read<TaskProvider>().deleteTask(taskId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 8),
            Expanded(child: _buildTaskList()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/add-task');
          if (!context.mounted) return;
          context.read<TaskProvider>().loadTodayTasks();
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (i) {
          switch (i) {
            case 1:
              Navigator.pushNamed(context, '/stats');
              break;
            case 2:
              Navigator.pushNamed(context, '/achievements');
              break;
            case 3:
              Navigator.pushNamed(context, '/settings');
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats'),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: 'Badges'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Consumer<XpProvider>(
      builder: (context, xp, _) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Row(
            children: [
              LevelBadge(level: xp.level),
              const SizedBox(width: 12),
              Expanded(
                child: XpBar(currentXp: xp.xpInCurrentLevel, xpNeeded: xp.xpNeeded),
              ),
              const SizedBox(width: 12),
              StreakBadge(streak: xp.currentStreak),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTaskList() {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, _) {
        final tasks = taskProvider.tasks;

        if (tasks.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.task_alt, size: 64, color: AppTheme.textSecondary.withValues(alpha: 0.4)),
                const SizedBox(height: 16),
                const Text(
                  'No tasks yet today',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 18),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tap + to add your first task!',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 80),
          itemCount: tasks.length,
          itemBuilder: (context, i) {
            final task = tasks[i];
            return TaskTile(
              task: task,
              onToggle: () => _onTaskToggle(task.id!),
              onDismissed: () => _onTaskDismissed(task.id!),
            );
          },
        );
      },
    );
  }
}
