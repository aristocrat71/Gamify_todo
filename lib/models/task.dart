class Task {
  final int? id;
  final String title;
  final String difficulty; // 'easy', 'medium', 'hard'
  final bool isCompleted;
  final String createdAt; // ISO date: '2026-03-04'
  final String? completedAt; // ISO datetime, nullable

  const Task({
    this.id,
    required this.title,
    required this.difficulty,
    this.isCompleted = false,
    required this.createdAt,
    this.completedAt,
  });

  Task copyWith({
    int? id,
    String? title,
    String? difficulty,
    bool? isCompleted,
    String? createdAt,
    String? completedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      difficulty: difficulty ?? this.difficulty,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'difficulty': difficulty,
      'is_completed': isCompleted ? 1 : 0,
      'created_at': createdAt,
      'completed_at': completedAt,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int?,
      title: map['title'] as String,
      difficulty: map['difficulty'] as String,
      isCompleted: (map['is_completed'] as int) == 1,
      createdAt: map['created_at'] as String,
      completedAt: map['completed_at'] as String?,
    );
  }
}
