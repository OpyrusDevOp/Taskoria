import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'quest.g.dart';

@HiveType(typeId: 0)
enum QuestType {
  @HiveField(0)
  main,
  @HiveField(1)
  side,
  @HiveField(2)
  recurrent,
  @HiveField(3)
  challenge,
  @HiveField(4)
  urgent,
  @HiveField(5)
  event,
}

@HiveType(typeId: 1)
enum QuestStatus {
  @HiveField(0)
  pending,
  @HiveField(1)
  due,
  @HiveField(2)
  overdue,
  @HiveField(3)
  completed,
  @HiveField(4)
  missed,
}

@HiveType(typeId: 2)
enum QuestDifficulty {
  @HiveField(0)
  easy,
  @HiveField(1)
  medium,
  @HiveField(2)
  hard,
}

@HiveType(typeId: 3)
enum Priority {
  @HiveField(0)
  low,
  @HiveField(1)
  medium,
  @HiveField(2)
  high,
}

@HiveType(typeId: 4)
enum RecurrenceType {
  @HiveField(0)
  daily,
  @HiveField(1)
  interval,
  @HiveField(2)
  weekly,
}

@HiveType(typeId: 5)
class RecurrencePattern {
  @HiveField(0)
  RecurrenceType type;

  @HiveField(1)
  int? interval; // For interval type (2-6 days)

  @HiveField(2)
  String? startDay; // Starting weekday (e.g., "Monday")

  RecurrencePattern({required this.type, this.interval, this.startDay});
}

@HiveType(typeId: 6)
class StreakData {
  @HiveField(0)
  int current;

  @HiveField(1)
  int best;

  @HiveField(2)
  DateTime? lastCompleted;

  @HiveField(3)
  DateTime? nextDue;

  StreakData({
    this.current = 0,
    this.best = 0,
    this.lastCompleted,
    this.nextDue,
  });
}

@HiveType(typeId: 7)
class Quest extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  QuestType type;

  @HiveField(4)
  int baseXP;

  @HiveField(5)
  QuestDifficulty difficulty;

  @HiveField(6)
  QuestStatus status;

  @HiveField(7)
  Priority priority;

  @HiveField(8)
  String category;

  @HiveField(9)
  DateTime createdAt;

  @HiveField(10)
  DateTime? dueDate;

  @HiveField(11)
  DateTime? completedAt;

  @HiveField(12)
  RecurrencePattern? recurrencePattern;

  @HiveField(13)
  StreakData? streak;

  Quest({
    String? id,
    required this.title,
    required this.description,
    required this.type,
    required this.baseXP,
    this.difficulty = QuestDifficulty.medium,
    this.status = QuestStatus.pending,
    this.priority = Priority.medium,
    this.category = 'Work 💼',
    DateTime? createdAt,
    this.dueDate,
    this.completedAt,
    this.recurrencePattern,
    this.streak,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now();

  Quest copyWith({
    String? title,
    String? description,
    QuestType? type,
    int? baseXP,
    QuestDifficulty? difficulty,
    QuestStatus? status,
    Priority? priority,
    String? category,
    DateTime? dueDate,
    DateTime? completedAt,
    RecurrencePattern? recurrencePattern,
    StreakData? streak,
  }) {
    return Quest(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      baseXP: baseXP ?? this.baseXP,
      difficulty: difficulty ?? this.difficulty,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      createdAt: createdAt,
      dueDate: dueDate ?? this.dueDate,
      completedAt: completedAt ?? this.completedAt,
      recurrencePattern: recurrencePattern ?? this.recurrencePattern,
      streak: streak ?? this.streak,
    );
  }
}
