import 'package:hive/hive.dart';

part 'quest_completion.g.dart';

@HiveType(typeId: 8)
class QuestCompletion extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String questId; // Can be Quest or DailyQuest ID

  @HiveField(2)
  DateTime completedAt;

  @HiveField(3)
  int xpEarned;

  @HiveField(4)
  bool isDaily;

  @HiveField(5)
  int? streakCount; // Only for daily quests

  @HiveField(6)
  bool wasOverdue;

  QuestCompletion({
    required this.id,
    required this.questId,
    required this.completedAt,
    required this.xpEarned,
    this.isDaily = false,
    this.streakCount,
    this.wasOverdue = false,
  });
}
