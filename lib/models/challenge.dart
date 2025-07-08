import 'package:hive/hive.dart';
import 'enums.dart';

// part 'challenge.g.dart';

@HiveType(typeId: 6)
class Challenge extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  int baseReward;

  @HiveField(4)
  QuestFrequency frequency;

  @HiveField(5)
  DateTime startingDay;

  @HiveField(6)
  DateTime createdAt;

  @HiveField(7)
  DateTime? completedAt;

  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.baseReward,
    required this.frequency,
    required this.startingDay,
    required this.createdAt,
    this.completedAt,
  });
}
