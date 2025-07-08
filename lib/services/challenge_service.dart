import '../models/challenge.dart';
import 'hive_service.dart';

class ChallengeService {
  static Future<List<Challenge>> getAllChallenges() async {
    return HiveService.challengesBox.values.toList();
  }

  static Future<Challenge?> getChallenge(String id) async {
    return HiveService.challengesBox.get(id);
  }

  static Future<void> addChallenge(Challenge challenge) async {
    await HiveService.challengesBox.put(challenge.id, challenge);
  }

  static Future<void> updateChallenge(Challenge challenge) async {
    await HiveService.challengesBox.put(challenge.id, challenge);
  }

  static Future<void> deleteChallenge(String id) async {
    await HiveService.challengesBox.delete(id);
  }
}
