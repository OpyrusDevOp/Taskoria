import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskoria/data/datasources/quest_datasource.dart';
import 'package:taskoria/data/models/quest.dart';
import 'package:taskoria/domain/repositories/quest_repository.dart';

// FutureProvider to ensure data source initialization
final questDataSourceFutureProvider = FutureProvider<QuestDataSource>((
  ref,
) async {
  final dataSource = QuestDataSource();
  await dataSource.init(); // Ensure initialization
  return dataSource;
});

final questRepositoryProvider = Provider<QuestRepository>((ref) {
  // Use the initialized data source from FutureProvider
  final dataSource = ref.watch(questDataSourceFutureProvider).value;
  if (dataSource == null) {
    throw Exception('QuestDataSource not initialized');
  }
  return QuestRepository(dataSource);
});

final questListProvider =
    StateNotifierProvider<QuestListNotifier, AsyncValue<List<Quest>>>((ref) {
      return QuestListNotifier(ref.read(questRepositoryProvider));
    });

class QuestListNotifier extends StateNotifier<AsyncValue<List<Quest>>> {
  final QuestRepository _repository;

  QuestListNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadQuests();
  }

  Future<void> loadQuests() async {
    try {
      state = const AsyncValue.loading();
      final quests = await _repository.getAllQuests();
      state = AsyncValue.data(quests);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addQuest(Quest quest) async {
    try {
      await _repository.saveQuest(quest);
      final quests = await _repository.getAllQuests();
      state = AsyncValue.data(quests);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateQuest(Quest quest) async {
    try {
      await _repository.updateQuest(quest);
      final quests = await _repository.getAllQuests();
      state = AsyncValue.data(quests);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteQuest(String id) async {
    try {
      await _repository.deleteQuest(id);
      final quests = await _repository.getAllQuests();
      state = AsyncValue.data(quests);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> completeQuest(String id) async {
    try {
      final quest = await _repository.getQuestById(id);
      if (quest != null) {
        final updatedQuest = quest.copyWith(
          status: QuestStatus.completed,
          completedAt: DateTime.now(),
        );
        await _repository.updateQuest(updatedQuest);
        final quests = await _repository.getAllQuests();
        state = AsyncValue.data(quests);
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> checkOverdueQuests() async {
    final quests = state.value ?? [];
    bool wasUpdated = false;
    List<Quest> updatedQuests = [];

    for (var quest in quests) {
      // Only check pending quests with a due date
      if (quest.status == QuestStatus.pending && quest.dueDate != null) {
        if (quest.dueDate!.isBefore(DateTime.now())) {
          // Mark as missed
          final failedQuest = quest.copyWith(status: QuestStatus.missed);
          updatedQuests.add(failedQuest);
          wasUpdated = true;
          // TODO: Apply penalty to user profile here if needed
        } else {
          updatedQuests.add(quest);
        }
      } else {
        updatedQuests.add(quest);
      }
    }

    if (wasUpdated) {
      // Batch update all changed quests
      for (var quest in updatedQuests) {
        await _repository.updateQuest(quest);
      }
      state = AsyncValue.data(updatedQuests);
    }
  }
}
