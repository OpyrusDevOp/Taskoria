import 'package:flutter/foundation.dart';

import '../models/quest.dart';
import '../models/challenge.dart';
import '../models/challenge_occurrence.dart';
import '../models/enums.dart';
import 'quest_service.dart';
import 'challenge_service.dart';
import 'challenge_occurrence_service.dart';
import 'user_profile_service.dart';
import 'utilitary.dart';

class AdventureService {
  // 1. Complete a quest (main, side, urgent, specialEvent)
  static Future<void> completeQuest(String questId) async {
    final quest = await QuestService.getQuest(questId);
    if (quest == null || quest.status != QuestStatus.pending) return;

    // Mark as completed
    quest.status = QuestStatus.completed;
    quest.completedAt = DateTime.now();
    await QuestService.updateQuest(quest);

    // Reward user
    final profile = await UserProfileService.getProfile();
    if (profile != null) {
      final rewardXP = Utilitary.questRewardXP(
        quest.type,
        profile.currentLevel,
      );
      profile.totalXP += rewardXP;
      profile.totalQuestsCompleted += 1;

      // Level up if needed
      final newLevel = Utilitary.levelFromXP(profile.totalXP);
      if (newLevel > profile.currentLevel) {
        profile.currentLevel = newLevel;
        profile.currentRank = Utilitary.calculateRank(newLevel);
        // Optionally: trigger level-up notification
        await _notifyLevelUp(newLevel, profile.currentRank);
      }
      await UserProfileService.saveProfile(profile);
    }
    // Optionally: trigger quest completion notification
    await _notifyQuestCompleted(quest);
  }

  // 2. Mark overdue quests (should be called in background/periodically)
  static Future<void> processOverdueQuests() async {
    final quests = await QuestService.getAllQuests();
    final now = DateTime.now();
    for (final quest in quests) {
      if (quest.status == QuestStatus.pending &&
          quest.dueDateTime != null &&
          now.isAfter(quest.dueDateTime!)) {
        quest.status = QuestStatus.overdue;
        await QuestService.updateQuest(quest);

        // Optionally: penalize user
        final profile = await UserProfileService.getProfile();
        if (profile != null) {
          final lostXP = Utilitary.xpLostOnOverdue(
            Utilitary.questRewardXP(quest.type, profile.currentLevel),
          );
          profile.totalXP -= lostXP;
          if (profile.totalXP < 0) profile.totalXP = 0;
          profile.totalStreaksBroken += 1;
          final newLevel = Utilitary.levelFromXP(profile.totalXP);
          if (newLevel < profile.currentLevel) {
            profile.currentLevel = newLevel;
            profile.currentRank = Utilitary.calculateRank(newLevel);
          }
          await UserProfileService.saveProfile(profile);
        }
        // Optionally: trigger overdue notification
        await _notifyQuestOverdue(quest);
      }
    }
  }

  // 3. Complete a challenge occurrence
  static Future<void> completeChallengeOccurrence(String occurrenceId) async {
    final occ = await ChallengeOccurrenceService.getOccurrence(occurrenceId);
    if (occ == null || occ.completedAt != null) return;

    occ.completedAt = DateTime.now();
    await ChallengeOccurrenceService.updateOccurrence(occ);

    // Reward user
    final profile = await UserProfileService.getProfile();
    final challenge = await ChallengeService.getChallenge(occ.challengeId);
    if (profile != null && challenge != null) {
      final rewardXP = occ.reward;
      profile.totalXP += rewardXP;
      profile.totalQuestsCompleted += 1;

      // Level up if needed
      final newLevel = Utilitary.levelFromXP(profile.totalXP);
      if (newLevel > profile.currentLevel) {
        profile.currentLevel = newLevel;
        profile.currentRank = Utilitary.calculateRank(newLevel);
        await _notifyLevelUp(newLevel, profile.currentRank);
      }
      await UserProfileService.saveProfile(profile);
    }
    // Optionally: trigger challenge completion notification
    await _notifyChallengeCompleted(challenge!);
  }

  // 4. Generate next challenge occurrence (should be called daily or on app open)
  static Future<void> generateChallengeOccurrences() async {
    final challenges = await ChallengeService.getAllChallenges();
    final now = DateTime.now();

    for (final challenge in challenges) {
      // Find the last occurrence
      final occurrences =
          await ChallengeOccurrenceService.getOccurrencesForChallenge(
            challenge.id,
          );
      DateTime lastDate = challenge.startingDay;
      if (occurrences.isNotEmpty) {
        occurrences.sort((a, b) => b.dateInstance.compareTo(a.dateInstance));
        lastDate = occurrences.first.dateInstance;
      }
      // Calculate next occurrence date
      final nextDate = Utilitary.nextChallengeOccurrence(
        lastDate,
        challenge.frequency,
      );
      // If next occurrence is today or earlier and not already created, create it
      if (!occurrences.any((o) => o.dateInstance == nextDate) &&
          !nextDate.isAfter(now)) {
        final occ = ChallengeOccurrence(
          id: '${challenge.id}_${nextDate.toIso8601String()}',
          challengeId: challenge.id,
          reward: Utilitary.questRewardXP(
            QuestType.challenge,
            0,
          ), // or use user level
          dateInstance: nextDate,
          completedAt: null,
        );
        await ChallengeOccurrenceService.addOccurrence(occ);
      }
    }
  }

  // 5. Retrieve all quests (optionally filter by status/type)
  static Future<List<Quest>> getQuests({
    QuestStatus? status,
    QuestType? type,
  }) async {
    final quests = await QuestService.getAllQuests();
    return quests.where((q) {
      final statusMatch = status == null || q.status == status;
      final typeMatch = type == null || q.type == type;
      return statusMatch && typeMatch;
    }).toList();
  }

  // 6. Retrieve all challenge occurrences (optionally filter by completion)
  static Future<List<ChallengeOccurrence>> getChallengeOccurrences({
    bool? completed,
  }) async {
    final occs = await ChallengeOccurrenceService.getAllOccurrences();
    return occs.where((o) {
      if (completed == null) return true;
      return completed ? o.completedAt != null : o.completedAt == null;
    }).toList();
  }

  static Future<List<Quest>> getTodayActiveQuests() async {
    final allQuests = await QuestService.getAllQuests();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day, 23, 59, 59);
    return allQuests.where((quest) {
      if (quest.dueDateTime == null) return false;
      return !quest.dueDateTime!.isAfter(today) &&
          quest.status == QuestStatus.pending;
    }).toList();
  }

  /// Get all active challenge occurrences for today (not completed)
  static Future<List<ChallengeOccurrence>> getTodayActiveChallenges() async {
    final allOccurrences = await ChallengeOccurrenceService.getAllOccurrences();
    final now = DateTime.now();
    return allOccurrences.where((occ) {
      final occDate = occ.dateInstance;
      final isToday =
          occDate.year == now.year &&
          occDate.month == now.month &&
          occDate.day == now.day;
      return isToday && occ.completedAt == null;
    }).toList();
  }

  // 7. Level up notification (stub)
  static Future<void> _notifyLevelUp(int level, UserRank rank) async {
    // TODO: Integrate with your notification system
    if (kDebugMode) {
      print('Level up! New level: $level, Rank: $rank');
    }
  }

  // 8. Quest completion notification (stub)
  static Future<void> _notifyQuestCompleted(Quest quest) async {
    // TODO: Integrate with your notification system
    if (kDebugMode) {
      print('Quest completed: ${quest.title}');
    }
  }

  // 9. Quest overdue notification (stub)
  static Future<void> _notifyQuestOverdue(Quest quest) async {
    // TODO: Integrate with your notification system
    if (kDebugMode) {
      print('Quest overdue: ${quest.title}');
    }
  }

  // 10. Challenge completion notification (stub)
  static Future<void> _notifyChallengeCompleted(Challenge challenge) async {
    // TODO: Integrate with your notification system
    if (kDebugMode) {
      print('Challenge completed: ${challenge.title}');
    }
  }

  // 11. Background process (call this periodically, e.g. with WorkManager)
  static Future<void> runBackgroundProcesses() async {
    await processOverdueQuests();
    await generateChallengeOccurrences();
    // Add more background logic as needed
  }
}
