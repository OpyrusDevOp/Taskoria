// lib/types/event_type.dart
import '../models/quest.dart';

/// Base class for all events
abstract class AppEvent {}

/// -------------------- QUEST EVENTS --------------------

/// Global quest update event (any quest change)
class QuestEvent extends AppEvent {
  final Quest quest;
  QuestEvent(this.quest);
}

/// Fired when a new quest is created
class QuestCreated extends QuestEvent {
  QuestCreated(super.quest);
}

/// Fired when a quest is updated (status, title, etc.)
class QuestUpdated extends QuestEvent {
  QuestUpdated(super.quest);
}

/// Fired when a quest is completed successfully
class QuestCompleted extends QuestEvent {
  QuestCompleted(super.quest);
}

/// Fired when a quest becomes overdue/failed
class QuestFailed extends QuestEvent {
  QuestFailed(super.quest);
}

/// Fired when a quest is deleted
class QuestDeleted extends AppEvent {
  final String questId;
  QuestDeleted(this.questId);
}

/// -------------------- PROFILE / XP EVENTS --------------------

/// Global profile update event (any profile change)
class ProfileEvent extends AppEvent {}

/// Fired when XP is gained
class XpGained extends ProfileEvent {
  final int xp;
  XpGained(this.xp);
}

/// Fired when XP is lost (penalty)
class XpLost extends ProfileEvent {
  final int xp;
  XpLost(this.xp);
}

/// Fired when profile level changes
class LevelUp extends ProfileEvent {
  final int newLevel;
  LevelUp(this.newLevel);
}

/// Fired when profile rank changes
class RankChanged extends ProfileEvent {
  final String newRank;
  RankChanged(this.newRank);
}

