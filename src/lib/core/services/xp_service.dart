import 'package:taskoria/data/models/quest.dart';

class XPService {
  static const Map<QuestType, int> baseXPValues = {
    QuestType.main: 100,
    QuestType.side: 60,
    QuestType.challenge: 30,
    QuestType.urgent: 80,
    QuestType.event: 200,
  };

  static const Map<int, int> recurrentXPValues = {
    1: 40, // Daily
    2: 60, // Every 2 days
    3: 80, // Every 3 days
    4: 90, // Every 4 days
    5: 100, // Every 5 days
    6: 110, // Every 6 days
    7: 150, // Weekly
  };

  static int calculateXP(Quest quest, int userLevel, {int streakBonus = 0}) {
    int baseXP = _getBaseXP(quest);
    double levelMultiplier = 1 + (0.05 * userLevel);
    return (baseXP * levelMultiplier).floor() + streakBonus;
  }

  static int _getBaseXP(Quest quest) {
    if (quest.type == QuestType.recurrent && quest.recurrencePattern != null) {
      int interval = quest.recurrencePattern!.type == RecurrenceType.daily
          ? 1
          : quest.recurrencePattern!.interval ?? 7;
      return recurrentXPValues[interval] ?? 40;
    }
    return baseXPValues[quest.type] ?? 0;
  }

  static int calculateStreakBonus(RecurrenceType type, int streakCount) {
    const bonusMultipliers = {
      RecurrenceType.daily: 5,
      RecurrenceType.interval: 3,
      RecurrenceType.weekly: 10,
    };

    const maxBonus = {
      RecurrenceType.daily: 50,
      RecurrenceType.interval: 30,
      RecurrenceType.weekly: 100,
    };

    int bonus = streakCount * (bonusMultipliers[type] ?? 0);
    return bonus < (maxBonus[type] ?? 0) ? bonus : (maxBonus[type] ?? 0);
  }
}
