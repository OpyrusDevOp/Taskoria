import 'package:Taskoria/core/utilities/xp_utility.dart';
import 'package:Taskoria/models/enums.dart';
import 'package:Taskoria/models/quest.dart';
import 'package:Taskoria/repositories/base/quest_repository.dart';
import 'package:Taskoria/repositories/hive/hive_quest_repository.dart';
import 'package:Taskoria/services/profile_service.dart';
import 'package:uuid/uuid.dart';

class QuestService {
  late final QuestRepository dataSource;

  static QuestService? _instance;

  QuestService._() {
    dataSource = HiveQuestRepository();
  }

  static QuestService get instance {
    _instance ??= QuestService._();
    return _instance!;
  }

  Future<void> addQuest(Quest quest) async {
    bool added = false;

    var profile = await ProfileService.instance.getProfile();
    quest.reward = XpUtilities.calculateQuestRewardXp(
      profile!.level,
      quest.type,
    );
    quest.penalty = XpUtilities.calculateQuestPenaltyXp(
      profile.level,
      quest.type,
    );

    while (!added) {
      try {
        await dataSource.addQuest(quest);
        added = true;
      } catch (ex) {
        quest.id = Uuid().v4();
      }
    }
  }

  Future<Quest?> getQuest(String id) async {
    return await dataSource.getQuest(id);
  }

  Future<List<Quest>> getQuests({int page = 0, int limit = 10}) async {
    var quests = await dataSource.getQuests();

    return quests.skip(page * limit).take(limit).toList();
  }

  Future<List<Quest>> getQuestsByType(
    QuestType type, {
    int page = 0,
    int limit = 10,
  }) async => await getQuestsBy(
    (Quest quest) => quest.type == type,
    page: page,
    limit: limit,
  );

  Future<List<Quest>> searchQuest(
    String keywords, {
    int page = 0,
    int limit = 10,
  }) async => await getQuestsBy(
    (quest) {
      var lowercaseKeyword = keywords.toLowerCase();

      return quest.title.toLowerCase().contains(lowercaseKeyword) ||
          quest.description!.toLowerCase().contains(lowercaseKeyword);
    },
    page: page,
    limit: limit,
  );

  Future<List<Quest>> getQuestsBy(
    bool Function(Quest) test, {
    int page = 0,
    int limit = 10,
  }) async {
    var quests = await dataSource.getQuests();

    return quests.where(test).skip(page * limit).take(limit).toList();
  }

  void completeQuest(Quest quest) async {
    if (quest.status != QuestStatus.pending) return;
    quest.status = QuestStatus.completed;
    await updateQuest(quest);
  }

  void overdueQuest(Quest quest) async {
    if (quest.status != QuestStatus.pending) return;

    quest.status = QuestStatus.failed;
    await updateQuest(quest);
  }

  Future<void> updateQuest(Quest quest) async => dataSource.updateQuest(quest);

  Future<void> deleteQuest(String id) async => dataSource.deleteQuest(id);
}
