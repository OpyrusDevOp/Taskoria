import 'package:hive/hive.dart';
import 'enums.dart';

part 'user_profile.g.dart';

@HiveType(typeId: 4)
class UserProfile extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  int totalXP;

  @HiveField(3)
  int currentLevel;

  @HiveField(4)
  UserRank rank;

  @HiveField(5)
  DateTime createdAt;

  @HiveField(6)
  DateTime lastActiveAt;

  @HiveField(7)
  int totalQuestsCompleted;

  @HiveField(8)
  int totalStreaksBroken;

  UserProfile({
    required this.id,
    required this.name,
    this.totalXP = 0,
    this.currentLevel = 0,
    this.rank = UserRank.newcomer,
    required this.createdAt,
    required this.lastActiveAt,
    this.totalQuestsCompleted = 0,
    this.totalStreaksBroken = 0,
  });
}
