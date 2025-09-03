import 'package:hive_flutter/adapters.dart';
import 'package:uuid/uuid.dart';
import 'enums.dart';

part 'quest.g.dart';

@HiveType(typeId: 2)
class Quest {
  @HiveField(0)
  String id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String? description;
  @HiveField(3)
  QuestType type;
  @HiveField(4)
  QuestStatus status;
  @HiveField(5)
  int reward;
  @HiveField(6)
  int penalty;
  @HiveField(7)
  DateTime dueTime;

  Quest({
    String? id,
    QuestStatus? status,
    required this.title,
    required this.type,
    required this.dueTime,
    this.reward = 0,
    this.penalty = 0,
    this.description,
  }) : id = id ?? Uuid().v4().toString(),
       status = status ?? QuestStatus.pending;

  bool isOverdue(DateTime time) => dueTime.isBefore(time);
}
