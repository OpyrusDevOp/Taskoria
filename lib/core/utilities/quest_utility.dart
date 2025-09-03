import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../models/enums.dart';

class QuestUtility {
  static Color getQuestTypeColor(QuestType type) {
    switch (type) {
      case QuestType.main:
        return AppTheme.mainQuestColor;
      case QuestType.side:
        return AppTheme.sideQuestColor;
      case QuestType.urgent:
        return AppTheme.urgentQuestColor;
      case QuestType.event:
        return AppTheme.eventColor;
    }
  }

  static String getQuestTypeDisplayName(QuestType type) {
    switch (type) {
      case QuestType.main:
        return 'Main Quest';
      case QuestType.side:
        return 'Side Quest';
      case QuestType.urgent:
        return 'Urgent Quest';
      case QuestType.event:
        return 'Special Event';
    }
  }

  static QuestType getQuestTypeFromDisplayName(String displayName) {
    switch (displayName) {
      case 'Main Quest':
        return QuestType.main;
      case 'Side Quest':
        return QuestType.side;
      case 'Urgent Quest':
        return QuestType.urgent;
      case 'Special Event':
        return QuestType.event;
      default:
        return QuestType.main;
    }
  }

  static String formatDueTime(DateTime dueTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final questDate = DateTime(dueTime.year, dueTime.month, dueTime.day);

    if (questDate == today) {
      return 'Today, ${_formatTime(dueTime)}';
    } else if (questDate == tomorrow) {
      return 'Tomorrow, ${_formatTime(dueTime)}';
    } else {
      return '${dueTime.day}/${dueTime.month}/${dueTime.year}, ${_formatTime(dueTime)}';
    }
  }

  static String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }

  static String getPriorityFromQuestType(QuestType type) {
    switch (type) {
      case QuestType.urgent:
        return 'High';
      case QuestType.main:
        return 'Medium';
      case QuestType.side:
        return 'Low';
      case QuestType.event:
        return 'Medium';
    }
  }

  static String getCategoryFromTitle(String title) {
    // Simple categorization based on keywords
    final lowerTitle = title.toLowerCase();
    if (lowerTitle.contains('work') ||
        lowerTitle.contains('project') ||
        lowerTitle.contains('meeting') ||
        lowerTitle.contains('report')) {
      return 'Work 💼';
    } else if (lowerTitle.contains('workout') ||
        lowerTitle.contains('health') ||
        lowerTitle.contains('exercise')) {
      return 'Health 💪';
    } else if (lowerTitle.contains('learn') ||
        lowerTitle.contains('study') ||
        lowerTitle.contains('course')) {
      return 'Learning 📚';
    } else {
      return 'Personal 😊';
    }
  }
}
