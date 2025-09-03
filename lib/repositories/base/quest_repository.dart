import 'package:Taskoria/models/quest.dart';

abstract class QuestRepository {
  // Insert
  Future<void> addQuest(Quest quest);

  //Retrieve
  Future<Quest?> getQuest(String id);
  Future<Iterable<Quest>> getQuests();

  Future<void> updateQuest(Quest quest);

  Future<void> deleteQuest(String id);
}
