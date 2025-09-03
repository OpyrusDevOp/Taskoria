import 'package:Taskoria/models/quest.dart';
import 'package:Taskoria/repositories/base/quest_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveQuestRepository extends QuestRepository {
  static const String boxName = "quests";

  Future<Box<Quest>> getBox() async => await Hive.openBox<Quest>(boxName);

  @override
  Future<void> addQuest(Quest quest) async {
    var box = await getBox();

    if (box.containsKey(quest.id)) throw Exception("Id already exists");

    box.put(quest.id, quest);
  }

  @override
  Future<void> deleteQuest(String id) async {
    var box = await getBox();

    box.delete(id);
  }

  @override
  Future<Quest?> getQuest(String id) async {
    var box = await getBox();

    return box.get(id);
  }

  @override
  Future<Iterable<Quest>> getQuests() async {
    var box = await getBox();
    return box.values.toList();
  }

  @override
  Future<void> updateQuest(Quest quest) async {
    var box = await getBox();

    if (box.containsKey(quest.id)) throw Exception("Id already exists");

    box.put(quest.id, quest);
  }
}
