import 'dart:math';

import 'package:taskoria/models/enums.dart';

class Utilitary {
  static const int _baseXP = 50;
  static int xpForLevel(
    int level, {
    int baseXP = _baseXP,
    double growth = 1.8,
  }) {
    // Level 0 to 1: baseXP, Level 1 to 2: baseXP * growth, etc.
    return (baseXP * pow(growth, level)).round();
  }

  static int levelFromXP(int xp, {int baseXP = _baseXP, double growth = 1.8}) {
    int level = 0;
    int totalXP = 0;
    while (true) {
      int nextXP = xpForLevel(level, baseXP: baseXP, growth: growth);
      if (xp < totalXP + nextXP) break;
      totalXP += nextXP;
      level++;
    }
    return level;
  }

  static double questTypeMultiplier(QuestType type) {
    switch (type) {
      case QuestType.mainQuest:
        return 1.0;
      case QuestType.sideQuest:
        return 0.7;
      case QuestType.urgentQuest:
        return 1.5;
      case QuestType.specialEvent:
        return 2.0;
      case QuestType.challenge:
        return 0.5;
    }
  }

  static int questRewardXP(QuestType type, int userLevel, {int baseXP = 50}) {
    // Optionally, scale baseXP with userLevel for more challenge
    double multiplier = questTypeMultiplier(type);
    // Example: reward grows slowly with level
    double levelBonus = 1 + (userLevel * 0.05);
    return (baseXP * multiplier * levelBonus).round();
  }

  static int xpLostOnOverdue(int rewardXP, {double penalty = 0.7}) {
    return (rewardXP * penalty).round();
  }

  static bool isQuestOverdue(DateTime dueDateTime, QuestStatus status) {
    return status == QuestStatus.pending && DateTime.now().isAfter(dueDateTime);
  }

  static DateTime nextChallengeOccurrence(
    DateTime startingDay,
    QuestFrequency frequency,
  ) {
    int daysInterval;
    switch (frequency) {
      case QuestFrequency.daily:
        daysInterval = 1;
        break;
      case QuestFrequency.every2Days:
        daysInterval = 2;
        break;
      case QuestFrequency.every3Days:
        daysInterval = 3;
        break;
      case QuestFrequency.every4Days:
        daysInterval = 4;
        break;
      case QuestFrequency.every5Days:
        daysInterval = 5;
        break;
      case QuestFrequency.every6Days:
        daysInterval = 6;
        break;
      case QuestFrequency.weekly:
        daysInterval = 7;
        break;
    }
    DateTime now = DateTime.now();
    DateTime next = startingDay;
    while (!next.isAfter(now)) {
      next = next.add(Duration(days: daysInterval));
    }
    return next;
  }

  static String formatRankName(String enumName) {
    // Insert a space before each uppercase letter (except the first)
    final withSpaces = enumName.replaceAllMapped(
      RegExp(r'([A-Z])'),
      (match) => ' ${match.group(0)}',
    );
    // Capitalize each word
    return withSpaces
        .split(' ')
        .map(
          (word) => word.isNotEmpty
              ? '${word[0].toUpperCase()}${word.substring(1)}'
              : '',
        )
        .join(' ')
        .trim();
  }

  static UserRank calculateRank(int level) {
    if (level < 0) throw Exception("Bad level number");
    switch (level) {
      case 0:
        return UserRank.newcomer;
      case <= 15:
        return UserRank.adventurer;
      case <= 30:
        return UserRank.explorer;
      case <= 45:
        return UserRank.questSeeker;
      case <= 60:
        return UserRank.trailblazer;
      case <= 70:
        return UserRank.pathfinder;
      case <= 75:
        return UserRank.taskSlayer;
      case <= 80:
        return UserRank.heroicAchiever;
      case <= 85:
        return UserRank.legendaryHunter;
      case <= 90:
        return UserRank.mastermind;
      case <= 95:
        return UserRank.questLegend;
      case <= 99:
        return UserRank.ultimateTasker;
      default:
        return UserRank.taskMaster;
    }
  }
}
