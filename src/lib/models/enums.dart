import 'package:hive/hive.dart';

part 'enums.g.dart';

@HiveType(typeId: 0)
enum QuestType {
  @HiveField(0)
  mainQuest,
  @HiveField(1)
  challenge,
  @HiveField(2)
  sideQuest,
  @HiveField(3)
  urgentQuest,
  @HiveField(4)
  specialEvent,
}

@HiveType(typeId: 1)
enum QuestFrequency {
  @HiveField(0)
  daily,
  @HiveField(1)
  every2Days,
  @HiveField(2)
  every3Days,
  @HiveField(3)
  every4Days,
  @HiveField(4)
  every5Days,
  @HiveField(5)
  every6Days,
  @HiveField(6)
  weekly,
}

@HiveType(typeId: 2)
enum UserRank {
  @HiveField(0)
  newcomer, // Level 0
  @HiveField(1)
  adventurer, // Level 1-15
  @HiveField(2)
  explorer, // Level 16-30
  @HiveField(3)
  questSeeker, // Level 31-45
  @HiveField(4)
  trailblazer, // Level 46-60
  @HiveField(5)
  pathfinder, // Level 61-70
  @HiveField(6)
  taskSlayer, // Level 71-75
  @HiveField(7)
  heroicAchiever, // Level 76-80
  @HiveField(8)
  legendaryHunter, // Level 81-85
  @HiveField(9)
  mastermind, // Level 86-90
  @HiveField(10)
  questLegend, // Level 91-95
  @HiveField(11)
  ultimateTasker, // Level 96-99
  @HiveField(12)
  taskMaster, // Level 100
}

@HiveType(typeId: 3)
enum QuestStatus {
  @HiveField(0)
  pending,
  @HiveField(1)
  completed,
  @HiveField(2)
  overdue,
  @HiveField(3)
  failed,
}
