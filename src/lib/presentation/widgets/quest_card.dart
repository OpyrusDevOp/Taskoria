import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:taskoria/core/theme/app_theme.dart';
import 'package:taskoria/data/models/quest.dart';
import 'package:taskoria/presentation/pages/quest_detail_page.dart';
import 'package:taskoria/presentation/providers/quest_provider.dart';

import '../providers/user_profile_provider.dart';

class QuestCard extends ConsumerWidget {
  final Quest quest;

  const QuestCard({super.key, required this.quest});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCompleted = quest.status == QuestStatus.completed;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.withValues(alpha: 0.1), width: 1),
        ),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => QuestDetailPage(quest: quest),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  children: [
                    // Category/Type badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getQuestTypeColor(
                          quest.type,
                        ).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        quest.category,
                        style: TextStyle(
                          color: _getQuestTypeColor(quest.type),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Priority badge
                    if (quest.priority == Priority.high)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryRed.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'High',
                          style: TextStyle(
                            color: AppTheme.primaryRed,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 12),

                // Quest title
                Text(
                  quest.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                    color: isCompleted
                        ? AppTheme.textSecondary
                        : AppTheme.textPrimary,
                  ),
                ),

                const SizedBox(height: 12),

                // Bottom row with details and action
                Row(
                  children: [
                    // Due time
                    if (quest.dueDate != null) ...[
                      Icon(
                        Icons.schedule_outlined,
                        size: 16,
                        color: AppTheme.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDueDate(quest.dueDate!),
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],

                    // XP reward
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, size: 14, color: Colors.amber[700]),
                          const SizedBox(width: 2),
                          Text(
                            '${quest.baseXP} XP',
                            style: TextStyle(
                              color: Colors.amber[700],
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // Complete button
                    if (quest.status != QuestStatus.completed)
                      GestureDetector(
                        onTap: () async {
                          // 1. Mark quest as completed
                          final updatedQuest = quest.copyWith(
                            status: QuestStatus.completed,
                            completedAt: DateTime.now(),
                          );
                          await ref
                              .read(questListProvider.notifier)
                              .updateQuest(updatedQuest);

                          // 2. Apply consequences to user profile
                          await ref
                              .read(userProfileProvider.notifier)
                              .applyQuestCompletion(updatedQuest);

                          // 3. Show feedback
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                'Quest Completed! Your stats have been updated.',
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppTheme.primaryRed,
                              width: 2,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check,
                            color: AppTheme.primaryRed,
                            size: 18,
                          ),
                        ),
                      )
                    else
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.check, color: Colors.white, size: 18),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getQuestTypeColor(QuestType type) {
    switch (type) {
      case QuestType.main:
        return AppTheme.mainQuestColor;
      case QuestType.side:
        return AppTheme.sideQuestColor;
      case QuestType.urgent:
        return AppTheme.urgentQuestColor;
      case QuestType.challenge:
        return AppTheme.challengeColor;
      case QuestType.event:
        return AppTheme.eventColor;
      case QuestType.recurrent:
        return AppTheme.recurrentColor;
    }
  }

  String _formatDueDate(DateTime dueDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final questDate = DateTime(dueDate.year, dueDate.month, dueDate.day);

    if (questDate == today) {
      return 'Today, ${DateFormat('h:mm a').format(dueDate)}';
    } else if (questDate == today.add(const Duration(days: 1))) {
      return 'Tomorrow, ${DateFormat('h:mm a').format(dueDate)}';
    } else {
      return DateFormat('MMM d, h:mm a').format(dueDate);
    }
  }
}

// Temporary extension to convert Quest to Map for QuestDetailPage compatibility
extension QuestMap on Quest {
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'priority': priority.name,
      'type': type.name,
      'baseXP': baseXP,
      'status': status.name,
      'difficulty': difficulty.name,
      'dueDate': dueDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'recurrencePattern': recurrencePattern != null
          ? {
              'type': recurrencePattern!.type.name,
              'interval': recurrencePattern!.interval,
              'startDay': recurrencePattern!.startDay,
            }
          : null,
      'streak': streak != null
          ? {
              'current': streak!.current,
              'best': streak!.best,
              'lastCompleted': streak!.lastCompleted?.toIso8601String(),
              'nextDue': streak!.nextDue?.toIso8601String(),
            }
          : null,
    };
  }

  // static String _formatDueDateForMap(DateTime dueDate) {
  //   final now = DateTime.now();
  //   final today = DateTime(now.year, now.month, now.day);
  //   final questDate = DateTime(dueDate.year, dueDate.month, dueDate.day);
  //
  //   if (questDate == today) {
  //     return 'Today, ${DateFormat('h:mm a').format(dueDate)}';
  //   } else if (questDate == today.add(const Duration(days: 1))) {
  //     return 'Tomorrow, ${DateFormat('h:mm a').format(dueDate)}';
  //   } else {
  //     return DateFormat('MMM d, h:mm a').format(dueDate);
  //   }
  // }
}
