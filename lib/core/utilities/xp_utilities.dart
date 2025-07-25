import 'dart:math';

import '../../data/enums.dart';

class XpUtilities {
  static const num baseXpFirstLevel = 100;
  static const num levelXpGrowthRate = 2.5;

  static int calculateLevel(int totalXp) {
    double temp =
        (totalXp / baseXpFirstLevel) * (levelXpGrowthRate - 1) +
        levelXpGrowthRate;
    double n = log(temp) / log(levelXpGrowthRate) - 1;

    return n.floor();
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

  static num calculateRequiredXp(int level) {
    return baseXpFirstLevel * pow(levelXpGrowthRate, level);
  }
}
