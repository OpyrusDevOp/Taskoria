import '../models/challenge_occurrence.dart';
import 'hive_service.dart';

class ChallengeOccurrenceService {
  static Future<List<ChallengeOccurrence>> getAllOccurrences() async {
    return HiveService.challengeOccurrencesBox.values.toList();
  }

  static Future<List<ChallengeOccurrence>> getOccurrencesForChallenge(
    String challengeId,
  ) async {
    return HiveService.challengeOccurrencesBox.values
        .where((occ) => occ.challengeId == challengeId)
        .toList();
  }

  static Future<ChallengeOccurrence?> getOccurrence(String id) async {
    return HiveService.challengeOccurrencesBox.get(id);
  }

  static Future<void> addOccurrence(ChallengeOccurrence occurrence) async {
    await HiveService.challengeOccurrencesBox.put(occurrence.id, occurrence);
  }

  static Future<void> updateOccurrence(ChallengeOccurrence occurrence) async {
    await HiveService.challengeOccurrencesBox.put(occurrence.id, occurrence);
  }

  static Future<void> deleteOccurrence(String id) async {
    await HiveService.challengeOccurrencesBox.delete(id);
  }

  static Future<void> completeOccurrence(
    String id,
    DateTime completedAt,
  ) async {
    final occ = await getOccurrence(id);
    if (occ == null) return;
    occ.completedAt = completedAt;
    await updateOccurrence(occ);
  }
}
