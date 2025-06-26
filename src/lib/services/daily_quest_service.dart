import 'package:taskoria/models/extensions.dart';

import '../models/daily_quest.dart';
import '../models/quest_completion.dart';
import '../models/enums.dart';
import 'hive_service.dart';
import 'user_service.dart';
import 'xp_service.dart';
import 'streak_service.dart';

class DailyQuestService {
  /// Create a new daily quest
  static Future<DailyQuest> createDailyQuest({
    required String title,
    String? description,
    required QuestType type,
    required QuestFrequency frequency,
    required int startWeekday, // 1-7 (Monday-Sunday)
    int importance = 3,
    int? customBaseXP,
  }) async {
    final now = DateTime.now();
    final startDate = _calculateStartDate(startWeekday);

    final dailyQuest = DailyQuest(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      type: type,
      baseXP: customBaseXP ?? 0,
      frequency: frequency,
      startWeekday: startWeekday,
      startDate: startDate,
      nextOccurrence: _calculateNextOccurrence(startDate, frequency),
      createdAt: now,
      importance: importance,
    );

    await HiveService.dailyQuestsBox.put(dailyQuest.id, dailyQuest);

    // Create initial streak
    await StreakService.createStreak(dailyQuest.id);

    return dailyQuest;
  }

  /// Complete a daily quest occurrence
  static Future<DailyQuest> completeDailyQuest(String dailyQuestId) async {
    final dailyQuest = HiveService.dailyQuestsBox.get(dailyQuestId);
    if (dailyQuest == null) throw Exception('Daily quest not found');

    if (!dailyQuest.isActive) {
      throw Exception('Daily quest is not active');
    }

    final userProfile = UserService.getCurrentProfile();
    final now = DateTime.now();

    // Check if already completed today
    if (dailyQuest.lastCompletedAt != null &&
        _isSameDay(dailyQuest.lastCompletedAt!, now)) {
      throw Exception('Daily quest already completed today');
    }

    // Calculate base XP
    final baseXP = XPService.calculateQuestXP(
      type: dailyQuest.type,
      importance: dailyQuest.importance,
      userLevel: userProfile.currentLevel,
      customBaseXP: dailyQuest.baseXP > 0 ? dailyQuest.baseXP : null,
    );

    // Update streak and get bonus XP
    final streak = await StreakService.updateStreak(dailyQuestId, true);
    final streakBonusXP = _calculateStreakBonus(baseXP, streak.currentStreak);
    final totalXP = baseXP + streakBonusXP;

    // Update daily quest
    dailyQuest.lastCompletedAt = now;
    dailyQuest.totalCompletions++;
    dailyQuest.nextOccurrence = _calculateNextOccurrence(
      now,
      dailyQuest.frequency,
    );
    await dailyQuest.save();

    // Record completion
    final completion = QuestCompletion(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      questId: dailyQuestId,
      completedAt: now,
      xpEarned: totalXP,
      isDaily: true,
      streakCount: streak.currentStreak,
    );
    await HiveService.completionsBox.put(completion.id, completion);

    // Update user XP and stats
    await UserService.updateXP(totalXP);
    await UserService.updateQuestStats(questCompleted: true);

    return dailyQuest;
  }

  /// Deactivate a daily quest (user stops doing it)
  static Future<DailyQuest> deactivateDailyQuest(String dailyQuestId) async {
    final dailyQuest = HiveService.dailyQuestsBox.get(dailyQuestId);
    if (dailyQuest == null) throw Exception('Daily quest not found');

    dailyQuest.isActive = false;
    await dailyQuest.save();

    // Deactivate associated streak
    await StreakService.deactivateStreak(dailyQuestId);

    return dailyQuest;
  }

  /// Reactivate a daily quest
  static Future<DailyQuest> reactivateDailyQuest(String dailyQuestId) async {
    final dailyQuest = HiveService.dailyQuestsBox.get(dailyQuestId);
    if (dailyQuest == null) throw Exception('Daily quest not found');

    dailyQuest.isActive = true;
    dailyQuest.nextOccurrence = _calculateNextOccurrence(
      DateTime.now(),
      dailyQuest.frequency,
    );
    await dailyQuest.save();

    // Reactivate associated streak
    await StreakService.reactivateStreak(dailyQuestId);

    return dailyQuest;
  }

  /// Get all daily quests
  static List<DailyQuest> getAllDailyQuests() {
    return HiveService.dailyQuestsBox.values.toList();
  }

  /// Get active daily quests
  static List<DailyQuest> getActiveDailyQuests() {
    return HiveService.dailyQuestsBox.values
        .where((quest) => quest.isActive)
        .toList();
  }

  /// Get daily quests due today
  static List<DailyQuest> getDailyQuestsDueToday() {
    final today = DateTime.now();
    return getActiveDailyQuests()
        .where(
          (quest) =>
              quest.nextOccurrence != null &&
              _isSameDay(quest.nextOccurrence!, today),
        )
        .toList();
  }

  /// Get daily quests that can be completed today
  static List<DailyQuest> getCompletableDailyQuests() {
    final today = DateTime.now();
    return getActiveDailyQuests().where((quest) {
      // Can complete if:
      // 1. Next occurrence is today or past
      // 2. Haven't completed today yet
      final canComplete =
          quest.nextOccurrence != null &&
          !today.isBefore(quest.nextOccurrence!);

      final notCompletedToday =
          quest.lastCompletedAt == null ||
          !_isSameDay(quest.lastCompletedAt!, today);

      return canComplete && notCompletedToday;
    }).toList();
  }

  /// Update all daily quest streaks (call this daily)
  static Future<void> updateAllStreaks() async {
    final activeDailyQuests = getActiveDailyQuests();
    final today = DateTime.now();

    for (final dailyQuest in activeDailyQuests) {
      // Check if quest was supposed to be completed but wasn't
      if (dailyQuest.nextOccurrence != null &&
          today.isAfter(dailyQuest.nextOccurrence!) &&
          (dailyQuest.lastCompletedAt == null ||
              !_isSameDay(
                dailyQuest.lastCompletedAt!,
                dailyQuest.nextOccurrence!,
              ))) {
        // Break streak for missed occurrence
        await StreakService.updateStreak(dailyQuest.id, false);

        // Update next occurrence
        dailyQuest.nextOccurrence = _calculateNextOccurrence(
          today,
          dailyQuest.frequency,
        );
        await dailyQuest.save();
      }
    }
  }

  /// Delete a daily quest
  static Future<void> deleteDailyQuest(String dailyQuestId) async {
    await HiveService.dailyQuestsBox.delete(dailyQuestId);

    // Delete associated streak
    await StreakService.deleteStreak(dailyQuestId);

    // Delete related completions
    final completions = HiveService.completionsBox.values
        .where((completion) => completion.questId == dailyQuestId)
        .toList();

    for (final completion in completions) {
      await HiveService.completionsBox.delete(completion.id);
    }
  }

  // Helper methods
  static DateTime _calculateStartDate(int startWeekday) {
    final now = DateTime.now();
    final currentWeekday = now.weekday;

    // If today is the start day, start today
    if (currentWeekday == startWeekday) {
      return DateTime(now.year, now.month, now.day);
    }

    // Otherwise, find the next occurrence of the start day
    int daysUntilStart = startWeekday - currentWeekday;
    if (daysUntilStart < 0) {
      daysUntilStart += 7; // Next week
    }

    final startDate = now.add(Duration(days: daysUntilStart));
    return DateTime(startDate.year, startDate.month, startDate.day);
  }

  static DateTime _calculateNextOccurrence(
    DateTime from,
    QuestFrequency frequency,
  ) {
    return from.add(Duration(days: frequency.days));
  }

  static bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  static int _calculateStreakBonus(int baseXP, int streakCount) {
    // Bonus increases with streak: 5% per streak day, capped at 50%
    final bonusPercentage = (streakCount * 0.05).clamp(0.0, 0.5);
    return (baseXP * bonusPercentage).round();
  }
}
