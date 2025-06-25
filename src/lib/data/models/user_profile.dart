import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'user_profile.g.dart';

@HiveType(typeId: 8)
class WeeklyProgress {
  @HiveField(0)
  int dailyQuestsCompleted;

  @HiveField(1)
  int mainQuestsCompleted;

  @HiveField(2)
  int currentStreakDays;

  WeeklyProgress({
    this.dailyQuestsCompleted = 0,
    this.mainQuestsCompleted = 0,
    this.currentStreakDays = 0,
  });
}

@HiveType(typeId: 9)
class UserProfile extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String username;

  @HiveField(2)
  int currentXP;

  @HiveField(3)
  int level;

  @HiveField(4)
  String rank;

  @HiveField(5)
  int totalQuestsCompleted;

  @HiveField(6)
  List<String> achievements;

  @HiveField(7)
  DateTime createdAt;

  @HiveField(8)
  DateTime lastLogin;

  @HiveField(9)
  WeeklyProgress weeklyProgress;

  UserProfile({
    String? id,
    required this.username,
    this.currentXP = 0,
    this.level = 1, // <-- CHANGE: Start at Level 1
    this.rank = 'Adventurer', // <-- CHANGE: Start as Adventurer
    this.totalQuestsCompleted = 0,
    this.achievements = const [],
    DateTime? createdAt,
    DateTime? lastLogin,
    WeeklyProgress? weeklyProgress,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now(),
       lastLogin = lastLogin ?? DateTime.now(),
       weeklyProgress = weeklyProgress ?? WeeklyProgress();

  UserProfile copyWith({
    String? username,
    int? currentXP,
    int? level,
    String? rank,
    int? totalQuestsCompleted,
    List<String>? achievements,
    DateTime? lastLogin,
    WeeklyProgress? weeklyProgress,
  }) {
    return UserProfile(
      id: id,
      username: username ?? this.username,
      currentXP: currentXP ?? this.currentXP,
      level: level ?? this.level,
      rank: rank ?? this.rank,
      totalQuestsCompleted: totalQuestsCompleted ?? this.totalQuestsCompleted,
      achievements: achievements ?? this.achievements,
      createdAt: createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      weeklyProgress: weeklyProgress ?? this.weeklyProgress,
    );
  }
}
