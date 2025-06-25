import 'package:hive/hive.dart';
import 'package:taskoria/data/models/quest.dart';

class QuestDataSource {
  static const String boxName = 'quests';
  Box<Quest>? _questBox;
  bool _isInitialized = false;

  Future<void> init() async {
    if (!_isInitialized) {
      _questBox = await Hive.openBox<Quest>(boxName);
      _isInitialized = true;
    }
  }

  Future<Box<Quest>> _getBox() async {
    if (!_isInitialized || _questBox == null) {
      await init();
    }
    return _questBox!;
  }

  Future<List<Quest>> getAllQuests() async {
    final box = await _getBox();
    return box.values.toList();
  }

  Future<Quest?> getQuestById(String id) async {
    final box = await _getBox();
    return box.values.firstWhere((quest) => quest.id == id);
  }

  Future<void> saveQuest(Quest quest) async {
    final box = await _getBox();
    await box.put(quest.id, quest);
  }

  Future<void> updateQuest(Quest quest) async {
    final box = await _getBox();
    await box.put(quest.id, quest);
  }

  Future<void> deleteQuest(String id) async {
    final box = await _getBox();
    await box.delete(id);
  }

  Future<List<Quest>> getQuestsByStatus(QuestStatus status) async {
    final box = await _getBox();
    return box.values.where((quest) => quest.status == status).toList();
  }

  Future<List<Quest>> getQuestsByType(QuestType type) async {
    final box = await _getBox();
    return box.values.where((quest) => quest.type == type).toList();
  }

  Future<List<Quest>> getQuestsByCategory(String category) async {
    final box = await _getBox();
    return box.values.where((quest) => quest.category == category).toList();
  }
}

