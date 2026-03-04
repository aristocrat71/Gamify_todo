class DayLog {
  final String date; // ISO date: '2026-03-04'
  final int tasksAdded;
  final int tasksCompleted;
  final int xpEarned;
  final int xpLost;

  const DayLog({
    required this.date,
    required this.tasksAdded,
    required this.tasksCompleted,
    required this.xpEarned,
    required this.xpLost,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'tasks_added': tasksAdded,
      'tasks_completed': tasksCompleted,
      'xp_earned': xpEarned,
      'xp_lost': xpLost,
    };
  }

  factory DayLog.fromMap(Map<String, dynamic> map) {
    return DayLog(
      date: map['date'] as String,
      tasksAdded: map['tasks_added'] as int,
      tasksCompleted: map['tasks_completed'] as int,
      xpEarned: map['xp_earned'] as int,
      xpLost: map['xp_lost'] as int,
    );
  }
}
