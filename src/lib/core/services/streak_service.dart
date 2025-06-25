import 'package:taskoria/data/models/quest.dart';

import 'xp_service.dart';

class StreakService {
  static const Map<RecurrenceType, int> missPenalties = {
    RecurrenceType.daily: -20,
    RecurrenceType.interval: -15,
    RecurrenceType.weekly: -30,
  };

  static const Map<RecurrenceType, int> gracePeriodHours = {
    RecurrenceType.daily: 2,
    RecurrenceType.interval: 4,
    RecurrenceType.weekly: 6,
  };

  static int updateStreak(
    Quest quest,
    DateTime currentDate, {
    bool completed = false,
  }) {
    if (quest.type != QuestType.recurrent ||
        quest.streak == null ||
        quest.recurrencePattern == null) {
      return 0;
    }

    StreakData streak = quest.streak!;
    RecurrenceType type = quest.recurrencePattern!.type;
    DateTime? nextDue = streak.nextDue;
    int bonus = 0;

    if (nextDue == null) {
      // First completion or initialization
      if (completed) {
        streak.current = 1;
        streak.best = 1;
        streak.lastCompleted = currentDate;
        streak.nextDue = calculateNextDue(quest, currentDate);
        bonus = XPService.calculateStreakBonus(type, streak.current);
      }
      return bonus;
    }

    // Check if missed (past due date + grace period)
    int graceHours = gracePeriodHours[type] ?? 0;
    DateTime graceDeadline = nextDue.add(Duration(hours: graceHours));
    if (currentDate.isAfter(graceDeadline) && !completed) {
      // Missed the deadline
      streak.current = 0;
      streak.nextDue = null; // Reset until next completion
      return missPenalties[type] ?? 0;
    }

    if (completed) {
      // Completed within window
      if (currentDate.isBefore(graceDeadline)) {
        streak.current += 1;
        if (streak.current > streak.best) {
          streak.best = streak.current;
          bonus += 100; // Record-breaking bonus
        }
        streak.lastCompleted = currentDate;
        streak.nextDue = calculateNextDue(quest, currentDate);
        bonus += XPService.calculateStreakBonus(type, streak.current);
      } else {
        // Completed but late, reset streak
        streak.current = 1;
        streak.lastCompleted = currentDate;
        streak.nextDue = calculateNextDue(quest, currentDate);
        bonus += XPService.calculateStreakBonus(type, streak.current);
      }
    }

    return bonus;
  }

  static DateTime calculateNextDue(Quest quest, DateTime completedDate) {
    if (quest.recurrencePattern == null) {
      return completedDate;
    }

    final pattern = quest.recurrencePattern!;
    switch (pattern.type) {
      case RecurrenceType.daily:
        return completedDate.add(const Duration(days: 1));
      case RecurrenceType.interval:
        return completedDate.add(Duration(days: pattern.interval ?? 2));
      case RecurrenceType.weekly:
        DateTime nextWeek = completedDate.add(const Duration(days: 7));
        return _adjustToWeekday(nextWeek, pattern.startDay ?? 'Monday');
    }
  }

  static DateTime _adjustToWeekday(DateTime date, String weekday) {
    const Map<String, int> weekdayMap = {
      'Monday': 1,
      'Tuesday': 2,
      'Wednesday': 3,
      'Thursday': 4,
      'Friday': 5,
      'Saturday': 6,
      'Sunday': 7,
    };
    int targetDay = weekdayMap[weekday] ?? 1;
    int currentDay = date.weekday;
    int daysToAdd = targetDay - currentDay;
    if (daysToAdd < 0) daysToAdd += 7;
    return date.add(Duration(days: daysToAdd));
  }

  static QuestStatus getQuestStatus(Quest quest, DateTime currentDate) {
    if (quest.type != QuestType.recurrent ||
        quest.streak == null ||
        quest.streak!.nextDue == null) {
      return quest.status;
    }

    final nextDue = quest.streak!.nextDue!;
    final type = quest.recurrencePattern?.type ?? RecurrenceType.daily;
    final graceHours = gracePeriodHours[type] ?? 0;
    final graceDeadline = nextDue.add(Duration(hours: graceHours));

    if (currentDate.isBefore(nextDue)) {
      return QuestStatus.pending;
    } else if (currentDate.isBefore(graceDeadline)) {
      return QuestStatus.due;
    } else {
      return QuestStatus.overdue;
    }
  }
}
