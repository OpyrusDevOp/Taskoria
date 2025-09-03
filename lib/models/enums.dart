import 'package:hive_flutter/adapters.dart';
part 'enums.g.dart';

enum FilterQuest { all, main, side, event, urgent }

@HiveType(typeId: 1)
enum UserRank {
  @HiveField(0)
  newcomer,

  @HiveField(1)
  adventurer,

  @HiveField(2)
  explorer,

  @HiveField(3)
  questSeeker,

  @HiveField(4)
  trailblazer,

  @HiveField(5)
  pathfinder,

  @HiveField(6)
  taskSlayer,

  @HiveField(7)
  heroicAchiever,

  @HiveField(8)
  legendaryHunter,

  @HiveField(9)
  mastermind,

  @HiveField(10)
  questLegend,

  @HiveField(11)
  ultimateTasker,

  @HiveField(12)
  taskMaster,
}

@HiveType(typeId: 3)
enum QuestType {
  @HiveField(0)
  main,
  @HiveField(1)
  side,
  @HiveField(2)
  event,
  @HiveField(3)
  urgent,
}

@HiveType(typeId: 4)
enum QuestStatus {
  @HiveField(0)
  pending,
  @HiveField(1)
  completed,
  @HiveField(2)
  failed,
}
