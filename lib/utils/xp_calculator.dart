import 'constants.dart';

/// XP reward for completing a task (before streak multiplier).
int calculateReward(String difficulty) {
  return xpRewards[difficulty] ?? 0;
}

/// XP penalty for missing a task (no multiplier applied).
int calculatePenalty(String difficulty) {
  return xpPenalties[difficulty] ?? 0;
}

/// Streak multiplier based on current streak length.
double getStreakMultiplier(int streak) {
  for (final tier in streakTiers) {
    if (streak >= tier.minDays) return tier.multiplier;
  }
  return 1.0;
}

/// XP needed to go from [currentLevel] to the next level.
int xpForNextLevel(int currentLevel) {
  return currentLevel * 100;
}
