import 'package:hive/hive.dart';

part 'streak.g.dart';

@HiveType(typeId: 7)
class Streak extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String dailyQuestId;

  @HiveField(2)
  int currentStreak;

  @HiveField(3)
  int bestStreak;

  @HiveField(4)
  DateTime? lastCompletedDate;

  @HiveField(5)
  DateTime? streakStartDate;

  @HiveField(6)
  bool isActive;

  @HiveField(7)
  int totalBreaks;

  @HiveField(8)
  DateTime? lastBreakDate;

  Streak({
    required this.id,
    required this.dailyQuestId,
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.lastCompletedDate,
    this.streakStartDate,
    this.isActive = true,
    this.totalBreaks = 0,
    this.lastBreakDate,
  });
}
