import 'dart:math';

import 'package:flutter/material.dart';

import '../../models/enums.dart';

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

  static int calculateRequiredXp(int level) {
    return (baseXpFirstLevel * pow(levelXpGrowthRate, level)).toInt();
  }

  static String formatRankName(UserRank rank) {
    switch (rank) {
      case UserRank.newcomer:
        return "New Comer";
      case UserRank.adventurer:
        return "Adventurer";
      case UserRank.explorer:
        return "Explorer";
      case UserRank.questSeeker:
        return "Quest Seeker";
      case UserRank.trailblazer:
        return "Trail Blazer";
      case UserRank.pathfinder:
        return "Path Finder";
      case UserRank.taskSlayer:
        return "Task Slayer";
      case UserRank.heroicAchiever:
        return "Heroic Achiever";
      case UserRank.legendaryHunter:
        return "Legendary Hunter";
      case UserRank.mastermind:
        return "Mastermind";
      case UserRank.questLegend:
        return "Quest Legend";
      case UserRank.ultimateTasker:
        return "Ultimate Tasker";
      default:
        return "Task Master";
    }
  }

  static IconData getRankIcon(UserRank rank) {
    switch (rank) {
      case UserRank.newcomer:
        return Icons.person_outline;
      case UserRank.adventurer:
        return Icons.hiking;
      case UserRank.explorer:
        return Icons.explore;
      case UserRank.questSeeker:
        return Icons.search;
      case UserRank.trailblazer:
        return Icons.trending_up;
      case UserRank.pathfinder:
        return Icons.navigation;
      case UserRank.taskSlayer:
        return Icons.flash_on;
      case UserRank.heroicAchiever:
        return Icons.shield;
      case UserRank.legendaryHunter:
        return Icons.military_tech;
      case UserRank.mastermind:
        return Icons.psychology;
      case UserRank.questLegend:
        return Icons.auto_awesome;
      case UserRank.ultimateTasker:
        return Icons.diamond;
      case UserRank.taskMaster:
        return Icons.emoji_events;
    }
  }

  static Color getRankColor(UserRank rank) {
    switch (rank) {
      case UserRank.newcomer:
        return Colors.grey;
      case UserRank.adventurer:
        return Colors.green;
      case UserRank.explorer:
        return Colors.blue;
      case UserRank.questSeeker:
        return Colors.purple;
      case UserRank.trailblazer:
        return Colors.orange;
      case UserRank.pathfinder:
        return Colors.teal;
      case UserRank.taskSlayer:
        return Colors.red;
      case UserRank.heroicAchiever:
        return Colors.indigo;
      case UserRank.legendaryHunter:
        return Colors.deepPurple;
      case UserRank.mastermind:
        return Colors.pink;
      case UserRank.questLegend:
        return Colors.amber;
      case UserRank.ultimateTasker:
        return Colors.cyan;
      case UserRank.taskMaster:
        return Colors.deepOrange;
    }
  }
}
