import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class StreakBadge extends StatelessWidget {
  final int streak;

  const StreakBadge({super.key, required this.streak});

  @override
  Widget build(BuildContext context) {
    final active = streak > 0;
    final color = active ? AppTheme.streakOrange : AppTheme.textSecondary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.local_fire_department, color: color, size: 28),
        const SizedBox(width: 4),
        TweenAnimationBuilder<int>(
          tween: IntTween(begin: 0, end: streak),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOut,
          builder: (context, value, _) {
            return Text(
              '$value',
              style: TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      ],
    );
  }
}
