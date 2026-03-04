# Gamify Todo

A gamified daily task manager built with Flutter. Set tasks, complete them to earn XP, level up, maintain streaks, and unlock achievements.

## Features

- **Daily Tasks** — Add tasks with Easy, Medium, or Hard difficulty. Check them off to earn XP in real-time.
- **XP & Leveling** — Earn XP for completing tasks (Easy: +10, Medium: +20, Hard: +35). Level up as you accumulate XP, with each level requiring more to advance.
- **Streaks** — Complete all tasks in a day to build your streak. Streaks of 3+ days grant an XP multiplier (up to 2x at 7+ days).
- **Penalties** — Miss a task by end of day and lose XP. Multi-day absences reset your streak.
- **Achievements** — Unlock 10 badges for milestones like completing your first task, reaching level 10, or hitting a 30-day streak.
- **Stats** — View a 7-day XP chart, completion rates, and lifetime stats.
- **Edit & Delete** — Edit task title/difficulty or delete tasks via the three-dot menu on each task.

## Tech Stack

- **Flutter** (Dart)
- **Provider** for state management
- **sqflite** for local database (tasks & day logs)
- **shared_preferences** for user profile (level, XP, streaks, achievements)
- **fl_chart** for stats visualization

## Architecture

Three `ChangeNotifier` providers manage app state:

- `TaskProvider` — Task CRUD, completion toggling
- `XpProvider` — XP calculation, leveling, streak tracking, day-transition logic
- `AchievementProvider` — Badge unlock checks and persistence

Services are plain Dart classes:

- `DatabaseService` — Singleton managing sqflite instance and queries
- `PrefsService` — Wrapper around shared_preferences

## Getting Started

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Build APK
flutter build apk --release
```

## How It Works

1. Add daily tasks with a difficulty level.
2. Tap the checkbox to complete a task and earn XP immediately.
3. When the app opens on a new day, any incomplete tasks from the previous day are penalized.
4. Build streaks by completing all tasks each day for bonus XP multipliers.
5. Track your progress in the Stats screen and collect all 10 achievements.
