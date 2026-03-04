import 'package:flutter/material.dart';

// --- Difficulty XP values ---

const Map<String, int> xpRewards = {
  'easy': 10,
  'medium': 20,
  'hard': 35,
};

const Map<String, int> xpPenalties = {
  'easy': 5,
  'medium': 10,
  'hard': 20,
};

// --- Streak multiplier thresholds ---

const List<StreakTier> streakTiers = [
  StreakTier(minDays: 7, multiplier: 2.0),
  StreakTier(minDays: 3, multiplier: 1.5),
  StreakTier(minDays: 0, multiplier: 1.0),
];

class StreakTier {
  final int minDays;
  final double multiplier;
  const StreakTier({required this.minDays, required this.multiplier});
}

// --- Achievement definitions ---

class AchievementDef {
  final String id;
  final String name;
  final String description;
  final IconData icon;

  const AchievementDef({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
  });
}

const List<AchievementDef> achievementDefs = [
  AchievementDef(
    id: 'first_blood',
    name: 'First Blood',
    description: 'Complete 1 task',
    icon: Icons.bolt,
  ),
  AchievementDef(
    id: 'hat_trick',
    name: 'Hat Trick',
    description: 'Complete 3 tasks in one day',
    icon: Icons.stars,
  ),
  AchievementDef(
    id: 'perfect_day',
    name: 'Perfect Day',
    description: 'Complete ALL tasks in a day',
    icon: Icons.wb_sunny,
  ),
  AchievementDef(
    id: 'on_fire',
    name: 'On Fire',
    description: 'Reach a 7-day streak',
    icon: Icons.local_fire_department,
  ),
  AchievementDef(
    id: 'unstoppable',
    name: 'Unstoppable',
    description: 'Reach a 30-day streak',
    icon: Icons.rocket_launch,
  ),
  AchievementDef(
    id: 'level_5',
    name: 'Rising Star',
    description: 'Reach level 5',
    icon: Icons.star,
  ),
  AchievementDef(
    id: 'level_10',
    name: 'Veteran',
    description: 'Reach level 10',
    icon: Icons.shield,
  ),
  AchievementDef(
    id: 'level_25',
    name: 'Legend',
    description: 'Reach level 25',
    icon: Icons.workspace_premium,
  ),
  AchievementDef(
    id: 'centurion',
    name: 'Centurion',
    description: 'Complete 100 total tasks',
    icon: Icons.looks_one,
  ),
  AchievementDef(
    id: 'hard_worker',
    name: 'Hard Worker',
    description: 'Complete 10 hard tasks',
    icon: Icons.fitness_center,
  ),
];
