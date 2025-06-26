import 'package:hive/hive.dart';
import 'enums.dart';

part 'daily_quest.g.dart';

@HiveType(typeId: 6)
class DailyQuest extends HiveObject {
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
  QuestFrequency frequency;

  @HiveField(6)
  int startWeekday; // 1-7 (Monday-Sunday)

  @HiveField(7)
  DateTime startDate;

  @HiveField(8)
  DateTime? nextOccurrence;

  @HiveField(9)
  bool isActive;

  @HiveField(10)
  DateTime createdAt;

  @HiveField(11)
  int importance; // 1-5 scale for XP scaling

  @HiveField(12)
  DateTime? lastCompletedAt;

  @HiveField(13)
  int totalCompletions;

  DailyQuest({
    required this.id,
    required this.title,
    this.description,
    required this.type,
    required this.baseXP,
    required this.frequency,
    required this.startWeekday,
    required this.startDate,
    this.nextOccurrence,
    this.isActive = true,
    required this.createdAt,
    this.importance = 3,
    this.lastCompletedAt,
    this.totalCompletions = 0,
  });
}
