// lib/presentation/pages/quest_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskoria/core/theme/app_theme.dart';
import 'package:taskoria/data/models/quest.dart';
import 'package:taskoria/presentation/providers/quest_provider.dart';
import 'package:taskoria/presentation/providers/user_profile_provider.dart';

class QuestDetailPage extends ConsumerWidget {
  final Quest quest;

  const QuestDetailPage({super.key, required this.quest});

  Future<void> _completeQuest(
    BuildContext context,
    WidgetRef ref,
    Quest quest,
  ) async {
    // 1. Mark quest as completed
    final updatedQuest = quest.copyWith(
      status: QuestStatus.completed,
      completedAt: DateTime.now(),
    );
    await ref.read(questListProvider.notifier).updateQuest(updatedQuest);

    // 2. Apply consequences to user profile
    await ref
        .read(userProfileProvider.notifier)
        .applyQuestCompletion(updatedQuest);

    // 3. Show feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Quest Completed! Your stats have been updated.'),
        backgroundColor: Colors.green,
      ),
    );

    // 4. Pop back
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCompleted = quest.status == QuestStatus.completed;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Quest Details'),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Implement edit
            },
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            onPressed: () {
              ref.read(questListProvider.notifier).deleteQuest(quest.id);
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // Category badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.primaryRed.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                quest.category,
                style: TextStyle(
                  color: AppTheme.primaryRed,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Title
            Text(
              quest.title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            // Details
            _buildDetailCard(
              Icons.schedule_outlined,
              'Due Date',
              quest.dueDate != null ? quest.dueDate.toString() : 'No due date',
            ),
            const SizedBox(height: 12),
            _buildDetailCard(
              Icons.flag_outlined,
              'Priority',
              quest.priority.name[0].toUpperCase() +
                  quest.priority.name.substring(1),
              valueColor: quest.priority == Priority.high
                  ? AppTheme.primaryRed
                  : null,
            ),
            const SizedBox(height: 12),
            _buildDetailCard(
              Icons.star_outline,
              'Reward',
              '${quest.baseXP} XP',
              valueColor: Colors.amber[700],
            ),
            const SizedBox(height: 24),
            // Description
            Text(
              'Description',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Text(
              quest.description,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.6,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            // Subtasks (if you have them, otherwise skip)
            // ...subtasks here...
            const SizedBox(height: 24),
            // Action buttons
            if (!isCompleted)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // TODO: Set reminder
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppTheme.primaryRed),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Set Reminder',
                        style: TextStyle(
                          color: AppTheme.primaryRed,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await _completeQuest(context, ref, quest);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Mark as Complete',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            if (isCompleted)
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 32,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Quest Completed!',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1), width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.textSecondary, size: 20),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? AppTheme.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
