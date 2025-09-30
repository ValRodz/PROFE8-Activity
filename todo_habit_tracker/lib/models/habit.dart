class Habit {
  final String id;
  final String name;
  final String description;
  final int targetDays;
  final int currentStreak;
  final int bestStreak;
  final List<DateTime> completedDates;
  final DateTime createdAt;
  final String color;

  Habit({
    required this.id,
    required this.name,
    this.description = '',
    this.targetDays = 7,
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.completedDates = const [],
    required this.createdAt,
    this.color = '#4CAF50',
  });

  Habit copyWith({
    String? id,
    String? name,
    String? description,
    int? targetDays,
    int? currentStreak,
    int? bestStreak,
    List<DateTime>? completedDates,
    DateTime? createdAt,
    String? color,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      targetDays: targetDays ?? this.targetDays,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      completedDates: completedDates ?? this.completedDates,
      createdAt: createdAt ?? this.createdAt,
      color: color ?? this.color,
    );
  }

  bool isCompletedToday() {
    final today = DateTime.now();
    return completedDates.any((date) =>
        date.year == today.year &&
        date.month == today.month &&
        date.day == today.day);
  }

  Habit markCompleted() {
    final today = DateTime.now();
    if (isCompletedToday()) {
      return this; // Already completed today
    }

    final newCompletedDates = [...completedDates, today];
    final newCurrentStreak = currentStreak + 1;
    final newBestStreak =
        newCurrentStreak > bestStreak ? newCurrentStreak : bestStreak;

    return copyWith(
      completedDates: newCompletedDates,
      currentStreak: newCurrentStreak,
      bestStreak: newBestStreak,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'targetDays': targetDays,
      'currentStreak': currentStreak,
      'bestStreak': bestStreak,
      'completedDates':
          completedDates.map((date) => date.toIso8601String()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'color': color,
    };
  }

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'] as String,
      name: json['name'] as String,
      description: (json['description'] as String?) ?? '',
      targetDays: (json['targetDays'] as int?) ?? 7,
      currentStreak: (json['currentStreak'] as int?) ?? 0,
      bestStreak: (json['bestStreak'] as int?) ?? 0,
      completedDates: (json['completedDates'] as List<dynamic>?)
              ?.map((dateStr) => DateTime.parse(dateStr as String))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      color: (json['color'] as String?) ?? '#4CAF50',
    );
  }
}
