import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class XpBar extends StatelessWidget {
  final int currentXp;
  final int xpNeeded;

  const XpBar({
    super.key,
    required this.currentXp,
    required this.xpNeeded,
  });

  @override
  Widget build(BuildContext context) {
    final progress = xpNeeded > 0 ? (currentXp / xpNeeded).clamp(0.0, 1.0) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: SizedBox(
            height: 14,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: progress),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) {
                return LinearProgressIndicator(
                  value: value,
                  backgroundColor: AppTheme.surfaceLight,
                  valueColor: const AlwaysStoppedAnimation(AppTheme.xpAmber),
                  minHeight: 14,
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '$currentXp / $xpNeeded XP',
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
