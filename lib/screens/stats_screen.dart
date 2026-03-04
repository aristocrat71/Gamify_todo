import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/day_log.dart';
import '../providers/xp_provider.dart';
import '../services/database_service.dart';
import '../theme/app_theme.dart';
import '../widgets/stat_chart.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  List<DayLog> _logs = [];
  int _totalCompleted = 0;
  int _totalAdded = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final db = DatabaseService.instance;
    final logs = await db.getLastNDaysLogs(7);
    final completed = await db.getTotalCompletedTasks();
    final added = logs.fold<int>(0, (sum, l) => sum + l.tasksAdded);

    setState(() {
      _logs = logs;
      _totalCompleted = completed;
      _totalAdded = added;
    });
  }

  @override
  Widget build(BuildContext context) {
    final xp = context.watch<XpProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Stats')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Last 7 Days',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            StatChart(logs: _logs),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _legendDot(AppTheme.successGreen, 'Earned'),
                const SizedBox(width: 20),
                _legendDot(AppTheme.penaltyRed, 'Lost'),
              ],
            ),
            const SizedBox(height: 24),
            _buildSummaryGrid(xp),
          ],
        ),
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
      ],
    );
  }

  Widget _buildSummaryGrid(XpProvider xp) {
    final completionRate = _totalAdded > 0
        ? ((_totalCompleted / _totalAdded) * 100).round()
        : 0;

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.6,
      children: [
        _statCard('Tasks Done', '$_totalCompleted', AppTheme.successGreen),
        _statCard('Completion', '$completionRate%', AppTheme.xpAmber),
        _statCard('Level', '${xp.level}', AppTheme.levelPurple),
        _statCard('Current Streak', '${xp.currentStreak}', AppTheme.streakOrange),
        _statCard('Best Streak', '${xp.bestStreak}', AppTheme.streakOrange),
        _statCard('Total XP', '${xp.totalXp}', AppTheme.xpAmber),
      ],
    );
  }

  Widget _statCard(String label, String value, Color accent) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accent.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value, style: TextStyle(color: accent, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
        ],
      ),
    );
  }
}
