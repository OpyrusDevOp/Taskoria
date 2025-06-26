import '../models/enums.dart';
// import '../models/quest.dart';
// import '../models/daily_quest.dart';

class XPService {
  // Base XP values for different quest types
  static const Map<QuestType, int> _baseXPValues = {
    QuestType.mainQuest: 50,
    QuestType.challenge: 10,
    QuestType.sideQuest: 30,
    QuestType.urgentQuest: 60,
    QuestType.specialEvent: 100,
  };

  // Level scaling factor
  static const double _levelScalingFactor = 0.1;

  /// Calculate XP reward for a quest based on type, importance, and user level
  static int calculateQuestXP({
    required QuestType type,
    required int importance,
    required int userLevel,
    int? customBaseXP,
  }) {
    final baseXP = customBaseXP ?? _baseXPValues[type] ?? 30;

    // Apply importance scaling (1-5 scale, where 3 is normal)
    final importanceMultiplier = importance / 3.0;

    // Apply level scaling
    final levelMultiplier = 1 + (_levelScalingFactor * userLevel);

    return (baseXP * importanceMultiplier * levelMultiplier).round();
  }

  /// Calculate XP loss for overdue quests (typically 50% of potential reward)
  static int calculateXPLoss({
    required QuestType type,
    required int importance,
    required int userLevel,
    int? customBaseXP,
  }) {
    final potentialXP = calculateQuestXP(
      type: type,
      importance: importance,
      userLevel: userLevel,
      customBaseXP: customBaseXP,
    );
    return (potentialXP * 0.5).round();
  }

  /// Calculate required XP for a specific level
  static int calculateRequiredXP(int level) {
    if (level == 0) return 0;

    int totalXP = 0;

    for (int i = 1; i <= level; i++) {
      if (i <= 10) {
        totalXP += 50; // Adventurer levels
      } else if (i <= 20) {
        totalXP += 80; // Explorer levels
      } else if (i <= 30) {
        totalXP += 100; // Quest Seeker levels
      } else if (i <= 40) {
        totalXP += 120; // Trailblazer levels
      } else if (i <= 50) {
        totalXP += 150; // Pathfinder levels
      } else if (i <= 60) {
        totalXP += 200; // Task Slayer levels
      } else if (i <= 70) {
        totalXP += 250; // Heroic Achiever levels
      } else if (i <= 80) {
        totalXP += 300; // Legendary Hunter levels
      } else if (i <= 85) {
        totalXP += 350; // Mastermind levels
      } else if (i <= 90) {
        totalXP += 500; // Quest Legend levels
      } else if (i <= 95) {
        totalXP += 600; // Ultimate Tasker levels
      } else if (i <= 99) {
        totalXP += 700; // Task Grandmaster levels
      } else if (i == 100) {
        totalXP += 5000; // TaskMaster level
      }
    }

    return totalXP;
  }

  /// Calculate current level from total XP
  static int calculateLevelFromXP(int totalXP) {
    if (totalXP <= 0) return 0;

    for (int level = 1; level <= 100; level++) {
      if (totalXP < calculateRequiredXP(level)) {
        return level - 1;
      }
    }
    return 100; // Max level
  }

  /// Calculate XP needed for next level
  static int calculateXPForNextLevel(int currentXP) {
    final currentLevel = calculateLevelFromXP(currentXP);
    if (currentLevel >= 100) return 0; // Max level reached

    final nextLevelRequiredXP = calculateRequiredXP(currentLevel + 1);
    return nextLevelRequiredXP - currentXP;
  }

  /// Calculate progress percentage to next level
  static double calculateLevelProgress(int currentXP) {
    final currentLevel = calculateLevelFromXP(currentXP);
    if (currentLevel >= 100) return 1.0; // Max level reached

    final currentLevelXP = calculateRequiredXP(currentLevel);
    final nextLevelXP = calculateRequiredXP(currentLevel + 1);
    final progressXP = currentXP - currentLevelXP;
    final levelRangeXP = nextLevelXP - currentLevelXP;

    return progressXP / levelRangeXP;
  }
}
