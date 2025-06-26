import 'package:hive/hive.dart';
import 'enums.dart';

part 'quest.g.dart';

@HiveType(typeId: 5)
class Quest extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String? description;

  @HiveField(3)
  QuestType type;

  @HiveField(4)
  int baseXP;

  @HiveField(5)
  DateTime? dueDateTime;

  @HiveField(6)
  QuestStatus status;

  @HiveField(7)
  DateTime createdAt;

  @HiveField(8)
  DateTime? completedAt;

  @HiveField(9)
  int importance; // 1-5 scale for XP scaling

  @HiveField(10)
  bool isRecurrent;

  @HiveField(11)
  int xpEarned; // Actual XP earned when completed

  @HiveField(12)
  int xpLost; // XP lost if overdue

  Quest({
    required this.id,
    required this.title,
    this.description,
    required this.type,
    required this.baseXP,
    this.dueDateTime,
    this.status = QuestStatus.pending,
    required this.createdAt,
    this.completedAt,
    this.importance = 3,
    this.isRecurrent = false,
    this.xpEarned = 0,
    this.xpLost = 0,
  });
}
