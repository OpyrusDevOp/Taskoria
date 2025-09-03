import 'package:hive_flutter/adapters.dart';
part 'enums.g.dart';

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

enum QuestType { main, side, event, urgent }

enum QuestStatus { pending, completed, failed }
