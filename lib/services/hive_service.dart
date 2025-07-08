import 'package:hive_flutter/hive_flutter.dart';
import '../models/challenge.dart';
import '../models/challenge_occurrence.dart';
import '../models/enums.dart';
import '../models/quest.dart';
import '../models/user_profile.dart';

class HiveService {
  static const String _userProfileBox = 'user_profile';
  static const String _questsBox = 'quests';
  static const String _challengesBox = 'challenges';
  static const String _challengeOccurrencesBox = 'challenge_occurrences';

  static Future<void> init() async {
    await Hive.initFlutter();

    // clearHiveData();

    // Register adapters (only once)
    Hive.registerAdapter(QuestTypeAdapter());
    Hive.registerAdapter(QuestStatusAdapter());
    Hive.registerAdapter(QuestFrequencyAdapter());
    Hive.registerAdapter(UserRankAdapter());
    Hive.registerAdapter(UserProfileAdapter());
    Hive.registerAdapter(QuestAdapter());
    Hive.registerAdapter(ChallengeAdapter());
    Hive.registerAdapter(ChallengeOccurrenceAdapter());

    // Open boxes
    await Hive.openBox<UserProfile>(_userProfileBox);
    await Hive.openBox<Quest>(_questsBox);
    await Hive.openBox<Challenge>(_challengesBox);
    await Hive.openBox<ChallengeOccurrence>(_challengeOccurrencesBox);
  }

  // Box getters
  static Box<UserProfile> get userProfileBox =>
      Hive.box<UserProfile>(_userProfileBox);

  static Box<Quest> get questsBox => Hive.box<Quest>(_questsBox);

  static Box<Challenge> get challengesBox =>
      Hive.box<Challenge>(_challengesBox);

  static Box<ChallengeOccurrence> get challengeOccurrencesBox =>
      Hive.box<ChallengeOccurrence>(_challengeOccurrencesBox);

  static Future<void> close() async {
    await Hive.close();
  }

  static Future<void> clearAllData() async {
    await userProfileBox.clear();
    await questsBox.clear();
    await challengesBox.clear();
    await challengeOccurrencesBox.clear();
  }

  static Future<void> clearHiveData() async {
    await Hive.initFlutter();
    try {
      await Hive.deleteBoxFromDisk(_userProfileBox);
      await Hive.deleteBoxFromDisk(_questsBox);
      await Hive.deleteBoxFromDisk(_challengesBox);
      await Hive.deleteBoxFromDisk(_challengeOccurrencesBox);
    } catch (e) {
      print('Error clearing boxes: $e');
    }
  }
}
