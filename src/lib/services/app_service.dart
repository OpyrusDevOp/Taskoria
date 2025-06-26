import '../models/enums.dart';
import 'hive_service.dart';
import 'user_service.dart';
import 'quest_service.dart';
import 'daily_quest_service.dart';
import 'streak_service.dart';

class AppService {
  static bool _initialized = false;

  /// Initialize the app
  static Future<void> initialize() async {
    if (_initialized) return;

    // await HiveService.clearHiveData();

    await HiveService.init();

    // Create default user profile if it doesn't exist
    UserService.getOrCreateProfile();

    // Update any overdue quests
    await QuestService.updateOverdueQuests();

    // Update daily quest streaks
    await DailyQuestService.updateAllStreaks();

    _initialized = true;
  }

  /// Daily maintenance tasks (call this when app starts each day)
  static Future<void> performDailyMaintenance() async {
    await QuestService.updateOverdueQuests();
    await DailyQuestService.updateAllStreaks();
  }

  /// Get app statistics
  static Map<String, dynamic> getAppStats() {
    final userStats = UserService.getUserStats();
    final streakStats = StreakService.getStreakStats();

    final totalQuests = QuestService.getAllQuests().length;
    final completedQuests = QuestService.getQuestsByStatus(
      QuestStatus.completed,
    ).length;

    final totalDailyQuests = DailyQuestService.getAllDailyQuests().length;
    final activeDailyQuests = DailyQuestService.getActiveDailyQuests().length;

    return {
      'user': userStats,
      'streaks': streakStats,
      'quests': {
        'total': totalQuests,
        'completed': completedQuests,
        'completionRate': totalQuests > 0 ? completedQuests / totalQuests : 0.0,
      },
      'dailyQuests': {'total': totalDailyQuests, 'active': activeDailyQuests},
    };
  }

  /// Reset all data (for testing or fresh start)
  static Future<void> resetAllData() async {
    await HiveService.clearAllData();
    UserService.getOrCreateProfile();
  }

  /// Close the app properly
  static Future<void> close() async {
    await HiveService.close();
    _initialized = false;
  }
}
