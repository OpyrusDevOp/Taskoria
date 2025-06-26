import 'enums.dart';

extension QuestFrequencyExtension on QuestFrequency {
  int get days {
    switch (this) {
      case QuestFrequency.daily:
        return 1;
      case QuestFrequency.every2Days:
        return 2;
      case QuestFrequency.every3Days:
        return 3;
      case QuestFrequency.every4Days:
        return 4;
      case QuestFrequency.every5Days:
        return 5;
      case QuestFrequency.every6Days:
        return 6;
      case QuestFrequency.weekly:
        return 7;
    }
  }
}

extension UserRankExtension on UserRank {
  String get displayName {
    switch (this) {
      case UserRank.newcomer:
        return 'Newcomer';
      case UserRank.adventurer:
        return 'Adventurer';
      case UserRank.explorer:
        return 'Explorer';
      case UserRank.questSeeker:
        return 'Quest Seeker';
      case UserRank.trailblazer:
        return 'Trailblazer';
      case UserRank.pathfinder:
        return 'Pathfinder';
      case UserRank.taskSlayer:
        return 'Task Slayer';
      case UserRank.heroicAchiever:
        return 'Heroic Achiever';
      case UserRank.legendaryHunter:
        return 'Legendary Hunter';
      case UserRank.mastermind:
        return 'Mastermind';
      case UserRank.questLegend:
        return 'Quest Legend';
      case UserRank.ultimateTasker:
        return 'Ultimate Tasker';
      case UserRank.taskMaster:
        return 'TaskMaster';
    }
  }

  static UserRank fromLevel(int level) {
    if (level == 0) return UserRank.newcomer;
    if (level <= 15) return UserRank.adventurer;
    if (level <= 30) return UserRank.explorer;
    if (level <= 45) return UserRank.questSeeker;
    if (level <= 60) return UserRank.trailblazer;
    if (level <= 70) return UserRank.pathfinder;
    if (level <= 75) return UserRank.taskSlayer;
    if (level <= 80) return UserRank.heroicAchiever;
    if (level <= 85) return UserRank.legendaryHunter;
    if (level <= 90) return UserRank.mastermind;
    if (level <= 95) return UserRank.questLegend;
    if (level <= 99) return UserRank.ultimateTasker;
    return UserRank.taskMaster;
  }
}
