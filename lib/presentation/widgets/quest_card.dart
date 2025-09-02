import 'package:flutter/material.dart';
import 'package:taskoria/core/theme/app_theme.dart';
import 'package:taskoria/presentation/pages/quest_detail_page.dart';

class QuestCard extends StatelessWidget {
  final Map<String, dynamic> quest;

  const QuestCard({super.key, required this.quest});

  @override
  Widget build(BuildContext context) {
    final isCompleted = quest['isCompleted'] as bool;
    final questType = quest['type'] as String;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.withOpacity(0.1), width: 1),
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
                        color: _getQuestTypeColor(questType).withOpacity(0.1),
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

                    // Priority badge
                    if (quest['priority'] == 'High')
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryRed.withOpacity(0.1),
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
                  quest['title'] as String,
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
                    Icon(
                      Icons.schedule_outlined,
                      size: 16,
                      color: AppTheme.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      quest['dueTime'] as String,
                      style: TextStyle(
                        color: AppTheme.textSecondary,
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
                        color: Colors.amber.withOpacity(0.1),
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
                      onTap: () {
                        // TODO: Toggle completion
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
      case 'main':
        return AppTheme.mainQuestColor;
      case 'side':
        return AppTheme.sideQuestColor;
      case 'urgent':
        return AppTheme.urgentQuestColor;
      case 'challenge':
        return AppTheme.challengeColor;
      case 'event':
        return AppTheme.eventColor;
      case 'recurrent':
        return AppTheme.recurrentColor;
      default:
        return AppTheme.primaryRed;
    }
  }
}
