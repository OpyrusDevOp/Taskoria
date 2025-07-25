import 'enums.dart';
import 'models/challenge_instance.dart';
import 'models/quest.dart';

enum AppEventType {
  questCompleted,
  questOverdue,
  questFailed,
  challengeInstanceCompleted,
  challengeInstanceOverdue,
  challengeInstanceFailed,
  levelUp,
  rankUp,
}

class AppEvent {
  final AppEventType type;
  final DateTime timestamp;
  final Map<String, dynamic> data;

  AppEvent({required this.type, DateTime? timestamp, this.data = const {}})
    : timestamp = timestamp ?? DateTime.now();
}

class QuestCompletedEvent extends AppEvent {
  final Quest quest;
  final int xpGained;
  final int? streakBonus;

  QuestCompletedEvent({
    required this.quest,
    required this.xpGained,
    this.streakBonus,
    super.timestamp,
  }) : super(
         type: AppEventType.questCompleted,
         data: {
           'questId': quest.id,
           'questTitle': quest.title,
           'questType': quest.type,
           'xpGained': xpGained,
           'streakBonus': streakBonus,
         },
       );
}

class QuestOverdueEvent extends AppEvent {
  final Quest quest;
  final int xpLost;

  QuestOverdueEvent({
    required this.quest,
    required this.xpLost,
    super.timestamp,
  }) : super(
         type: AppEventType.questOverdue,
         data: {
           'questId': quest.id,
           'questTitle': quest.title,
           'questType': quest.type,
           'xpLost': xpLost,
         },
       );
}

class ChallengeInstanceCompletedEvent extends AppEvent {
  final ChallengeInstance instance;
  final int xpGained;
  final int currentStreak;

  ChallengeInstanceCompletedEvent({
    required this.instance,
    required this.xpGained,
    required this.currentStreak,
    super.timestamp,
  }) : super(
         type: AppEventType.challengeInstanceCompleted,
         data: {
           'instanceId': instance.id,
           'challengeId': instance.challengeId,
           'instanceTitle': instance.title,
           'xpGained': xpGained,
           'currentStreak': currentStreak,
         },
       );
}

class ChallengeInstanceOverdueEvent extends AppEvent {
  final ChallengeInstance instance;
  final int xpLost;

  ChallengeInstanceOverdueEvent({
    required this.instance,
    required this.xpLost,
    super.timestamp,
  }) : super(
         type: AppEventType.challengeInstanceOverdue,
         data: {
           'instanceId': instance.id,
           'challengeId': instance.challengeId,
           'instanceTitle': instance.title,
           'xpLost': xpLost,
         },
       );
}

class LevelUpEvent extends AppEvent {
  final int oldLevel;
  final int newLevel;
  final UserRank oldRank;
  final UserRank newRank;
  final int totalXP;

  LevelUpEvent({
    required this.oldLevel,
    required this.newLevel,
    required this.oldRank,
    required this.newRank,
    required this.totalXP,
    super.timestamp,
  }) : super(
         type: AppEventType.levelUp,
         data: {
           'oldLevel': oldLevel,
           'newLevel': newLevel,
           'oldRank': oldRank,
           'newRank': newRank,
           'totalXP': totalXP,
         },
       );
}
