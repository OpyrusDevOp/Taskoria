import 'package:taskoria/data/datasources/quest_datasource.dart';
import 'package:taskoria/data/models/quest.dart';

class QuestRepository {
  final QuestDataSource _dataSource;

  QuestRepository(this._dataSource);

  Future<List<Quest>> getAllQuests() async {
    return await _dataSource.getAllQuests();
  }

  Future<Quest?> getQuestById(String id) async {
    return await _dataSource.getQuestById(id);
  }

  Future<void> saveQuest(Quest quest) async {
    await _dataSource.saveQuest(quest);
  }

  Future<void> updateQuest(Quest quest) async {
    await _dataSource.updateQuest(quest);
  }

  Future<void> deleteQuest(String id) async {
    await _dataSource.deleteQuest(id);
  }

  Future<List<Quest>> getQuestsByStatus(QuestStatus status) async {
    return await _dataSource.getQuestsByStatus(status);
  }

  Future<List<Quest>> getQuestsByType(QuestType type) async {
    return await _dataSource.getQuestsByType(type);
  }

  Future<List<Quest>> getQuestsByCategory(String category) async {
    return await _dataSource.getQuestsByCategory(category);
  }
}
