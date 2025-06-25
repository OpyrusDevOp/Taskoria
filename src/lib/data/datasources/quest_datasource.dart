import 'package:hive/hive.dart';
import 'package:taskoria/data/models/quest.dart';

class QuestDataSource {
  static const String boxName = 'quests';
  late Box<Quest> _questBox;

  Future<void> init() async {
    _questBox = await Hive.openBox<Quest>(boxName);
  }

  Future<List<Quest>> getAllQuests() async {
    return _questBox.values.toList();
  }

  Future<Quest?> getQuestById(String id) async {
    return _questBox.values.firstWhere((quest) => quest.id == id, orElse: null);
  }

  Future<void> saveQuest(Quest quest) async {
    await _questBox.put(quest.id, quest);
  }

  Future<void> updateQuest(Quest quest) async {
    await _questBox.put(quest.id, quest);
  }

  Future<void> deleteQuest(String id) async {
    await _questBox.delete(id);
  }

  Future<List<Quest>> getQuestsByStatus(QuestStatus status) async {
    return _questBox.values.where((quest) => quest.status == status).toList();
  }

  Future<List<Quest>> getQuestsByType(QuestType type) async {
    return _questBox.values.where((quest) => quest.type == type).toList();
  }

  Future<List<Quest>> getQuestsByCategory(String category) async {
    return _questBox.values
        .where((quest) => quest.category == category)
        .toList();
  }
}
