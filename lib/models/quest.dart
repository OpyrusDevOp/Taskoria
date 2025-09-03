import 'package:uuid/uuid.dart';

import 'enums.dart';

class Quest {
  String id;
  String title;
  String? description;
  QuestType type;
  QuestStatus status;
  int reward;
  int penalty;
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
