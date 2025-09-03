import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utilities/quest_utility.dart';
import '../../models/quest.dart';
import '../../models/enums.dart';
import '../../services/quest_service.dart';

class QuestDetailPage extends StatefulWidget {
  final Quest quest;

  const QuestDetailPage({super.key, required this.quest});

  @override
  State<QuestDetailPage> createState() => _QuestDetailPageState();
}

class _QuestDetailPageState extends State<QuestDetailPage> {
  late Quest _quest;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _quest = widget.quest;
  }

  @override
  Widget build(BuildContext context) {
    final category = QuestUtility.getCategoryFromTitle(_quest.title);
    final priority = QuestUtility.getPriorityFromQuestType(_quest.type);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.edit_outlined)),
          IconButton(
            onPressed: _deleteQuest,
            icon: const Icon(Icons.delete_outline),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: QuestUtility.getQuestTypeColor(
                  _quest.type,
                ).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    category,
                    style: TextStyle(
                      color: QuestUtility.getQuestTypeColor(_quest.type),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Title
            Text(
              _quest.title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
                decoration: _quest.status == QuestStatus.completed
                    ? TextDecoration.lineThrough
                    : null,
              ),
            ),

            const SizedBox(height: 24),

            // Details cards
            _buildDetailCard(
              icon: Icons.schedule_outlined,
              label: 'Due Date',
              value: QuestUtility.formatDueTime(_quest.dueTime),
            ),

            const SizedBox(height: 12),

            _buildDetailCard(
              icon: Icons.flag_outlined,
              label: 'Priority',
              value: priority,
              valueColor: priority == 'High' ? AppTheme.primaryRed : null,
            ),

            const SizedBox(height: 12),

            _buildDetailCard(
              icon: Icons.star_outline,
              label: 'Reward',
              value: '${_quest.reward} XP',
              valueColor: Colors.amber[700],
            ),

            const SizedBox(height: 12),

            _buildDetailCard(
              icon: Icons.category_outlined,
              label: 'Type',
              value: QuestUtility.getQuestTypeDisplayName(_quest.type),
              valueColor: QuestUtility.getQuestTypeColor(_quest.type),
            ),

            const SizedBox(height: 24),

            // Description section
            if (_quest.description != null &&
                _quest.description!.isNotEmpty) ...[
              Text(
                'Description',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Text(
                _quest.description!,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.6,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
            ],

            const Spacer(),

            // Action buttons
            if (_quest.status == QuestStatus.pending) ...[
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
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
                      onPressed: _isLoading ? null : _completeQuest,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Mark as Complete',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                    ),
                  ),
                ],
              ),
            ] else ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _quest.status == QuestStatus.completed
                      ? Colors.green.withValues(alpha: 0.1)
                      : Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _quest.status == QuestStatus.completed
                        ? Colors.green
                        : Colors.red,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _quest.status == QuestStatus.completed
                          ? Icons.check_circle
                          : Icons.cancel,
                      color: _quest.status == QuestStatus.completed
                          ? Colors.green
                          : Colors.red,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _quest.status == QuestStatus.completed
                          ? 'Quest Completed!'
                          : 'Quest Failed',
                      style: TextStyle(
                        color: _quest.status == QuestStatus.completed
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String label,
    required String value,
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

  Future<void> _completeQuest() async {
    setState(() {
      _isLoading = true;
    });

    try {
      QuestService.instance.completeQuest(_quest);
      setState(() {
        _quest.status = QuestStatus.completed;
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Quest completed! 🎉')));
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error completing quest: $e')));
      }
    }
  }

  Future<void> _deleteQuest() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Quest'),
        content: const Text('Are you sure you want to delete this quest?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await QuestService.instance.deleteQuest(_quest.id);
        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Quest deleted')));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error deleting quest: $e')));
        }
      }
    }
  }
}
