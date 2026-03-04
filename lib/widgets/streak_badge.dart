import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class StreakBadge extends StatelessWidget {
  final int streak;

  const StreakBadge({super.key, required this.streak});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.local_fire_department,
          color: streak > 0 ? AppTheme.streakOrange : AppTheme.textSecondary,
          size: 28,
        ),
        const SizedBox(width: 4),
        Text(
          '$streak',
          style: TextStyle(
            color: streak > 0 ? AppTheme.streakOrange : AppTheme.textSecondary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
