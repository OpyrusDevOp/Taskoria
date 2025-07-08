import '../models/enums.dart';
import '../models/quest.dart';
import 'hive_service.dart';

class QuestService {
  static Future<List<Quest>> getAllQuests() async {
    return HiveService.questsBox.values.toList();
  }

  static Future<Quest?> getQuest(String id) async {
    return HiveService.questsBox.get(id);
  }

  static Future<void> addQuest(Quest quest) async {
    await HiveService.questsBox.put(quest.id, quest);
  }

  static Future<void> updateQuest(Quest quest) async {
    await HiveService.questsBox.put(quest.id, quest);
  }

  static Future<void> deleteQuest(String id) async {
    await HiveService.questsBox.delete(id);
  }

  static Future<void> completeQuest(String id, DateTime completedAt) async {
    final quest = await getQuest(id);
    if (quest == null) return;
    quest.status = QuestStatus.completed;
    quest.completedAt = completedAt;
    await updateQuest(quest);
  }

  static Future<void> markOverdueQuests() async {
    final now = DateTime.now();
    final quests = await getAllQuests();
    for (final quest in quests) {
      if (quest.status == QuestStatus.pending &&
          quest.dueDateTime != null &&
          now.isAfter(quest.dueDateTime!)) {
        quest.status = QuestStatus.overdue;
        await updateQuest(quest);
      }
    }
  }
}
