import 'package:flutter/material.dart';
import 'package:taskoria/core/theme/app_theme.dart';

class QuestCard extends StatelessWidget {
  final Map<String, dynamic> quest;
  final Function(Map<String, dynamic>)? onComplete;
  final VoidCallback? onRefresh;

  const QuestCard({
    super.key,
    required this.quest,
    this.onComplete,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = quest['isCompleted'] as bool;
    final isOverdue = quest['isOverdue'] as bool? ?? false;
    final questType = quest['type'] as String;
    final priority = quest['priority'] as String? ?? '';
    final isDaily = quest['isDaily'] as bool? ?? false;
    final streak = quest['streak'] as int? ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isOverdue
                ? AppTheme.primaryRed.withValues(alpha: 0.3)
                : Colors.grey.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: InkWell(
          onTap: () {
            // TODO: Navigate to quest detail if needed
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
                          questType,
                        ).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        quest['category'] as String,
                        style: TextStyle(
                          color: _getQuestTypeColor(questType),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Daily quest streak indicator
                    if (isDaily && streak > 0) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.local_fire_department,
                              size: 12,
                              color: Colors.orange,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '$streak',
                              style: const TextStyle(
                                color: Colors.orange,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    // Priority badge
                    if (priority == 'High')
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryRed.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
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
                  quest['title'] as String,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                    color: isCompleted
                        ? AppTheme.textSecondary
                        : (isOverdue
                              ? AppTheme.primaryRed
                              : AppTheme.textPrimary),
                  ),
                ),
                const SizedBox(height: 12),
                // Bottom row with details and action
                Row(
                  children: [
                    // Due time
                    Icon(
                      isOverdue
                          ? Icons.warning_outlined
                          : Icons.schedule_outlined,
                      size: 16,
                      color: isOverdue
                          ? AppTheme.primaryRed
                          : AppTheme.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      quest['dueTime'] as String,
                      style: TextStyle(
                        color: isOverdue
                            ? AppTheme.primaryRed
                            : AppTheme.textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 16),
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
                            '${quest['xp']} XP',
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
                    GestureDetector(
                      onTap: isCompleted
                          ? null
                          : () {
                              onComplete?.call(quest);
                            },
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? Colors.green
                              : Colors.transparent,
                          border: Border.all(
                            color: isCompleted
                                ? Colors.green
                                : AppTheme.primaryRed,
                            width: 2,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check,
                          color: isCompleted
                              ? Colors.white
                              : AppTheme.primaryRed,
                          size: 18,
                        ),
                      ),
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

  Color _getQuestTypeColor(String type) {
    switch (type) {
      case 'mainQuest':
        return AppTheme.mainQuestColor;
      case 'sideQuest':
        return AppTheme.sideQuestColor;
      case 'urgentQuest':
        return AppTheme.urgentQuestColor;
      case 'challenge':
        return AppTheme.challengeColor;
      case 'specialEvent':
        return AppTheme.eventColor;
      default:
        return AppTheme.primaryRed;
    }
  }
}
