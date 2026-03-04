import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/achievement_provider.dart';
import '../utils/constants.dart';
import '../theme/app_theme.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final unlocked = context.watch<AchievementProvider>().unlocked;

    return Scaffold(
      appBar: AppBar(title: const Text('Achievements')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.95,
        ),
        itemCount: achievementDefs.length,
        itemBuilder: (context, i) {
          final def = achievementDefs[i];
          final isUnlocked = unlocked.contains(def.id);
          return _AchievementCard(def: def, isUnlocked: isUnlocked);
        },
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final AchievementDef def;
  final bool isUnlocked;

  const _AchievementCard({required this.def, required this.isUnlocked});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isUnlocked
              ? AppTheme.xpAmber.withValues(alpha: 0.5)
              : AppTheme.surfaceLight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            def.icon,
            size: 36,
            color: isUnlocked ? AppTheme.xpAmber : AppTheme.textSecondary.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 10),
          Text(
            def.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isUnlocked ? AppTheme.textPrimary : AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isUnlocked ? def.description : '???',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: isUnlocked
                  ? AppTheme.textSecondary
                  : AppTheme.textSecondary.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }
}
