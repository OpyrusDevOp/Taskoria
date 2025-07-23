import 'package:uuid/uuid.dart';

import '../enums.dart';

class Quest {
  String id;
  String title;
  String? description;
  QuestType type;
  DateTime dueTime;
  bool completed;
  int rewardXP;
  int penaltyXP;

  Quest({
    String? id,
    required this.title,
    this.description,
    this.type = QuestType.mainQuest,
    this.completed = false,
    required this.dueTime,
    required this.rewardXP,
    required this.penaltyXP,
  }) : id = id ?? const Uuid().v4();

  Quest copyWith({
    String? title,
    String? description,
    QuestType? type,
    DateTime? dueTime,
    bool? completed,
    int? rewardXP,
    int? penaltyXP,
  }) {
    return Quest(
      id: id,
      title: title ?? this.title,
      type: type ?? this.type,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      dueTime: dueTime ?? this.dueTime,
      rewardXP: rewardXP ?? this.rewardXP,
      penaltyXP: penaltyXP ?? this.penaltyXP,
    );
  }
}
