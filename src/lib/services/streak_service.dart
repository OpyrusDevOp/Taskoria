import '../models/streak.dart';
import 'hive_service.dart';
import 'user_service.dart';

class StreakService {
  /// Create a new streak for a daily quest
  static Future<Streak> createStreak(String dailyQuestId) async {
    final streak = Streak(
      id: 'streak_$dailyQuestId',
      dailyQuestId: dailyQuestId,
    );

    await HiveService.streaksBox.put(streak.id, streak);
    return streak;
  }

  /// Update streak (complete or break)
  static Future<Streak> updateStreak(
    String dailyQuestId,
    bool completed,
  ) async {
    final streakId = 'streak_$dailyQuestId';
    final streak = HiveService.streaksBox.get(streakId);

    if (streak == null) {
      throw Exception('Streak not found for daily quest: $dailyQuestId');
    }

    final now = DateTime.now();

    if (completed) {
      // Extend streak
      streak.currentStreak++;
      streak.lastCompletedDate = now;

      // Update best streak if current is better
      if (streak.currentStreak > streak.bestStreak) {
        streak.bestStreak = streak.currentStreak;
      }

      // Set streak start date if this is the first completion
      if (streak.streakStartDate == null) {
        streak.streakStartDate = now;
      }
    } else {
      // Break streak
      if (streak.currentStreak > 0) {
        streak.totalBreaks++;
        streak.lastBreakDate = now;

        // Update user stats
        await UserService.updateQuestStats(streakBroken: true);
      }

      streak.currentStreak = 0;
      streak.streakStartDate = null;
    }

    await streak.save();
    return streak;
  }

  /// Get streak for a daily quest
  static Streak? getStreak(String dailyQuestId) {
    final streakId = 'streak_$dailyQuestId';
    return HiveService.streaksBox.get(streakId);
  }

  /// Get all active streaks
  static List<Streak> getActiveStreaks() {
    return HiveService.streaksBox.values
        .where((streak) => streak.isActive && streak.currentStreak > 0)
        .toList();
  }

  /// Get best streaks (top performers)
  static List<Streak> getBestStreaks({int limit = 10}) {
    final streaks = HiveService.streaksBox.values.toList();
    streaks.sort((a, b) => b.bestStreak.compareTo(a.bestStreak));
    return streaks.take(limit).toList();
  }

  /// Deactivate streak (when daily quest is deactivated)
  static Future<Streak> deactivateStreak(String dailyQuestId) async {
    final streakId = 'streak_$dailyQuestId';
    final streak = HiveService.streaksBox.get(streakId);

    if (streak == null) {
      throw Exception('Streak not found for daily quest: $dailyQuestId');
    }

    streak.isActive = false;
    await streak.save();
    return streak;
  }

  /// Reactivate streak (when daily quest is reactivated)
  static Future<Streak> reactivateStreak(String dailyQuestId) async {
    final streakId = 'streak_$dailyQuestId';
    final streak = HiveService.streaksBox.get(streakId);

    if (streak == null) {
      throw Exception('Streak not found for daily quest: $dailyQuestId');
    }

    streak.isActive = true;
    await streak.save();
    return streak;
  }

  /// Delete streak (when daily quest is deleted)
  static Future<void> deleteStreak(String dailyQuestId) async {
    final streakId = 'streak_$dailyQuestId';
    await HiveService.streaksBox.delete(streakId);
  }

  /// Get streak statistics
  static Map<String, dynamic> getStreakStats() {
    final allStreaks = HiveService.streaksBox.values.toList();
    final activeStreaks = allStreaks.where((s) => s.isActive).toList();

    final totalActiveStreaks = activeStreaks.length;
    final currentStreaks = activeStreaks
        .where((s) => s.currentStreak > 0)
        .length;
    final longestCurrentStreak = activeStreaks.isEmpty
        ? 0
        : activeStreaks
              .map((s) => s.currentStreak)
              .reduce((a, b) => a > b ? a : b);
    final longestEverStreak = allStreaks.isEmpty
        ? 0
        : allStreaks.map((s) => s.bestStreak).reduce((a, b) => a > b ? a : b);
    final totalBreaks = allStreaks.fold<int>(
      0,
      (sum, s) => sum + s.totalBreaks,
    );

    return {
      'totalActiveStreaks': totalActiveStreaks,
      'currentActiveStreaks': currentStreaks,
      'longestCurrentStreak': longestCurrentStreak,
      'longestEverStreak': longestEverStreak,
      'totalStreakBreaks': totalBreaks,
    };
  }

  /// Calculate streak bonus XP
  static int calculateStreakBonusXP(int baseXP, int streakCount) {
    // Progressive bonus: 5% per streak day, capped at 100%
    final bonusPercentage = (streakCount * 0.05).clamp(0.0, 1.0);
    return (baseXP * bonusPercentage).round();
  }

  /// Check if streak is at risk (hasn't been completed recently)
  static bool isStreakAtRisk(Streak streak, Duration riskThreshold) {
    if (streak.lastCompletedDate == null || streak.currentStreak == 0) {
      return false;
    }

    final now = DateTime.now();
    final timeSinceLastCompletion = now.difference(streak.lastCompletedDate!);

    return timeSinceLastCompletion > riskThreshold;
  }

  /// Get streaks at risk
  static List<Streak> getStreaksAtRisk({Duration? riskThreshold}) {
    final threshold = riskThreshold ?? const Duration(days: 1);

    return getActiveStreaks()
        .where((streak) => isStreakAtRisk(streak, threshold))
        .toList();
  }
}
