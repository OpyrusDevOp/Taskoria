import 'package:hive/hive.dart';

import 'enums.dart';

// part 'quest.g.dart';

@HiveType(typeId: 5)
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
  int reward;

  @HiveField(5)
  DateTime? dueDateTime;

  @HiveField(6)
  QuestStatus status;

  @HiveField(7)
  DateTime createdAt;

  @HiveField(8)
  DateTime? completedAt;

  Quest({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.reward,
    this.dueDateTime,
    required this.status,
    required this.createdAt,
    this.completedAt,
  });
}
