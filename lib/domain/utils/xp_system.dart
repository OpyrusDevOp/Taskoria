import 'dart:math';

import '../../models/commons.dart';

/// XP & Level Curve Logic
class XpSystem {
  static const int maxLevel = 60;
  static const int maxExp = 1000000;
  static const double difficultyExponent = 2.5;

  // ---------------------------------------------------------------------------
  // XP & LEVEL CURVE LOGIC
  // ---------------------------------------------------------------------------

  /// Calculates total XP required to reach a specific [level].
  /// Formula: TotalXP = 1,000,000 * (Level / 60) ^ 2.5
  static int calculateRequiredExpForLevel(int level) {
    if (level <= 0) return 0;
    if (level >= maxLevel) return maxExp;
    return (maxExp * pow(level / maxLevel, difficultyExponent)).round();
  }

  /// Calculates the current Level based on total [currentExp].
  /// Formula: Level = 60 * (XP / 1,000,000) ^ 0.4
  static int calculateLevelFromExp(int currentExp) {
    if (currentExp <= 0) return 0;
    if (currentExp >= maxExp) return maxLevel;
    return (maxLevel * pow(currentExp / maxExp, 1 / difficultyExponent))
        .floor();
  }

  static Rank getRankForLevel(int level) {
    if (level <= 2) return Rank.starter;
    if (level <= 9) return Rank.grinder;
    if (level <= 19) return Rank.hustler;
    if (level <= 29) return Rank.hardWorker;
    if (level <= 39) return Rank.machine;
    if (level <= 49) return Rank.taskMaster;
    if (level <= 55) return Rank.grandArchitect;
    return Rank.visionary;
  }

  /// Returns the progress (0.0 to 1.0) towards the NEXT level.
  /// Useful for the XP bar UI.
  static double calculateLevelProgress(int currentExp) {
    int currentLevel = calculateLevelFromExp(currentExp);
    if (currentLevel >= maxLevel) return 1.0;

    int currentLevelExpStart = calculateRequiredExpForLevel(currentLevel);
    int nextLevelExpStart = calculateRequiredExpForLevel(currentLevel + 1);

    int expInCurrentLevel = currentExp - currentLevelExpStart;
    int expNeededForNextLevel = nextLevelExpStart - currentLevelExpStart;

    return (expInCurrentLevel / expNeededForNextLevel).clamp(0.0, 1.0);
  }
}
