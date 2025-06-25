// lib/core/services/quest_completion_service.dart
import 'package:taskoria/data/models/quest.dart';
import 'package:taskoria/data/models/user_profile.dart';
import 'package:taskoria/core/services/xp_service.dart';
import 'package:taskoria/core/services/level_service.dart';

class QuestCompletionService {
  static UserProfile applyConsequences(
    Quest completedQuest,
    UserProfile currentUserProfile,
  ) {
    // 1. Calculate Streak Bonus (if applicable)
    int streakBonus = 0;
    if (completedQuest.type == QuestType.recurrent &&
        completedQuest.recurrencePattern != null) {
      // Note: This is a simplified call. A full implementation would update the quest's streak data first.
      // For now, we assume the streak is being maintained.
      final currentStreak =
          currentUserProfile.weeklyProgress.currentStreakDays + 1;
      streakBonus = XPService.calculateStreakBonus(
        completedQuest.recurrencePattern!.type,
        currentStreak,
      );
    }

    // 2. Calculate Total XP Gained
    final xpGained = XPService.calculateXP(
      completedQuest,
      currentUserProfile.level,
      streakBonus: streakBonus,
    );

    // 3. Update User Profile Stats
    final newXP = currentUserProfile.currentXP + xpGained;
    final newLevel = LevelService.calculateLevel(newXP);
    final newRank = LevelService.getRank(newLevel);
    final newTotalCompleted = currentUserProfile.totalQuestsCompleted + 1;

    // 4. Check for Level Up to add an achievement
    List<String> newAchievements = List.from(currentUserProfile.achievements);
    if (newLevel > currentUserProfile.level) {
      newAchievements.add('Reached Level $newLevel!');
    }

    // 5. Return the updated profile
    return currentUserProfile.copyWith(
      currentXP: newXP,
      level: newLevel,
      rank: newRank,
      totalQuestsCompleted: newTotalCompleted,
      achievements: newAchievements,
      // TODO: Update weeklyProgress streak data
    );
  }
}
