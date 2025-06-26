import '../models/quest.dart';
import '../models/quest_completion.dart';
import '../models/enums.dart';
import 'hive_service.dart';
import 'user_service.dart';
import 'xp_service.dart';

class QuestService {
  /// Create a new quest
  static Future<Quest> createQuest({
    required String title,
    String? description,
    required QuestType type,
    DateTime? dueDateTime,
    int importance = 3,
    int? customBaseXP,
  }) async {
    final quest = Quest(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      type: type,
      baseXP: customBaseXP ?? 0,
      dueDateTime: dueDateTime,
      createdAt: DateTime.now(),
      importance: importance,
    );

    await HiveService.questsBox.put(quest.id, quest);
    return quest;
  }

  /// Complete a quest
  static Future<Quest> completeQuest(String questId) async {
    final quest = HiveService.questsBox.get(questId);
    if (quest == null) throw Exception('Quest not found');

    if (quest.status == QuestStatus.completed) {
      throw Exception('Quest already completed');
    }

    final userProfile = UserService.getCurrentProfile();
    final now = DateTime.now();

    // Check if quest is overdue
    final isOverdue =
        quest.dueDateTime != null && now.isAfter(quest.dueDateTime!);

    // Calculate XP
    final xpEarned = XPService.calculateQuestXP(
      type: quest.type,
      importance: quest.importance,
      userLevel: userProfile.currentLevel,
      customBaseXP: quest.baseXP > 0 ? quest.baseXP : null,
    );

    // Update quest
    quest.status = QuestStatus.completed;
    quest.completedAt = now;
    quest.xpEarned = xpEarned;
    await quest.save();

    // Record completion
    final completion = QuestCompletion(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      questId: questId,
      completedAt: now,
      xpEarned: xpEarned,
      wasOverdue: isOverdue,
    );
    await HiveService.completionsBox.put(completion.id, completion);

    // Update user XP and stats
    await UserService.updateXP(xpEarned);
    await UserService.updateQuestStats(questCompleted: true);

    return quest;
  }

  /// Mark quest as overdue and apply XP penalty
  static Future<Quest> markQuestOverdue(String questId) async {
    final quest = HiveService.questsBox.get(questId);
    if (quest == null) throw Exception('Quest not found');

    if (quest.status != QuestStatus.pending) return quest;

    final userProfile = UserService.getCurrentProfile();

    // Calculate XP loss
    final xpLoss = XPService.calculateXPLoss(
      type: quest.type,
      importance: quest.importance,
      userLevel: userProfile.currentLevel,
      customBaseXP: quest.baseXP > 0 ? quest.baseXP : null,
    );

    // Update quest
    quest.status = QuestStatus.overdue;
    quest.xpLost = xpLoss;
    await quest.save();

    // Apply XP penalty
    await UserService.updateXP(-xpLoss);

    return quest;
  }

  /// Get all quests
  static List<Quest> getAllQuests() {
    return HiveService.questsBox.values.toList();
  }

  /// Get quests by status
  static List<Quest> getQuestsByStatus(QuestStatus status) {
    return HiveService.questsBox.values
        .where((quest) => quest.status == status)
        .toList();
  }

  /// Get overdue quests
  static List<Quest> getOverdueQuests() {
    final now = DateTime.now();
    return HiveService.questsBox.values
        .where(
          (quest) =>
              quest.status == QuestStatus.pending &&
              quest.dueDateTime != null &&
              now.isAfter(quest.dueDateTime!),
        )
        .toList();
  }

  /// Update overdue quests (call this periodically)
  static Future<void> updateOverdueQuests() async {
    final overdueQuests = getOverdueQuests();

    for (final quest in overdueQuests) {
      await markQuestOverdue(quest.id);
    }
  }

  /// Delete a quest
  static Future<void> deleteQuest(String questId) async {
    await HiveService.questsBox.delete(questId);

    // Also delete related completions
    final completions = HiveService.completionsBox.values
        .where((completion) => completion.questId == questId)
        .toList();

    for (final completion in completions) {
      await HiveService.completionsBox.delete(completion.id);
    }
  }
}
