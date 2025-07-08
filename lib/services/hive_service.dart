import 'package:hive_flutter/hive_flutter.dart';
import '../models/challenge.dart';
import '../models/challenge_occurrence.dart';
import '../models/enums.dart';
import '../models/quest.dart';
import '../models/user_profile.dart';

class HiveService {
  static const String _userProfileBox = 'user_profile';
  static const String _questsBox = 'quests';
  static const String _dailyQuestsBox = 'daily_quests';
  static const String _streaksBox = 'streaks';
  static const String _completionsBox = 'completions';

  static Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(QuestTypeAdapter());
    Hive.registerAdapter(QuestStatusAdapter());
    Hive.registerAdapter(QuestFrequencyAdapter());
    Hive.registerAdapter(UserRankAdapter());
    Hive.registerAdapter(UserProfileAdapter());
    Hive.registerAdapter(QuestAdapter());
    Hive.registerAdapter(ChallengeAdapter());
    Hive.registerAdapter(ChallengeOccurrenceAdapter()); // Open boxes
    // await Hive.openBox<UserProfile>(_userProfileBox);
    // await Hive.openBox<Quest>(_questsBox);
    // await Hive.openBox<DailyQuest>(_dailyQuestsBox);
    // await Hive.openBox<Streak>(_streaksBox);
    // await Hive.openBox<QuestCompletion>(_completionsBox);
  }

  // Box getters
  // static Box<UserProfile> get userProfileBox =>
  //     Hive.box<UserProfile>(_userProfileBox);
  // static Box<Quest> get questsBox => Hive.box<Quest>(_questsBox);
  // static Box<DailyQuest> get dailyQuestsBox =>
  //     Hive.box<DailyQuest>(_dailyQuestsBox);
  // static Box<Streak> get streaksBox => Hive.box<Streak>(_streaksBox);
  // static Box<QuestCompletion> get completionsBox =>
  //     Hive.box<QuestCompletion>(_completionsBox);
  //
  // static Future<void> close() async {
  //   await Hive.close();
  // }
  //
  // static Future<void> clearAllData() async {
  //   await userProfileBox.clear();
  //   await questsBox.clear();
  //   await dailyQuestsBox.clear();
  //   await streaksBox.clear();
  //   await completionsBox.clear();
  // }
  //
  // static Future<void> clearHiveData() async {
  //   await Hive.initFlutter();
  //
  //   // Delete all existing boxes
  //   try {
  //     await Hive.deleteBoxFromDisk('user_profile');
  //     await Hive.deleteBoxFromDisk('quests');
  //     await Hive.deleteBoxFromDisk('daily_quests');
  //     await Hive.deleteBoxFromDisk('streaks');
  //     await Hive.deleteBoxFromDisk('completions');
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print('Error clearing boxes: $e');
  //     }
  //   }
  // }
}
