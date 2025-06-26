import 'package:flutter/material.dart';
import 'package:taskoria/core/theme/app_theme.dart';
import 'package:taskoria/models/extensions.dart';
import 'package:taskoria/models/daily_quest.dart';
import 'package:taskoria/services/quest_service.dart';
import 'package:taskoria/services/daily_quest_service.dart';

class QuestDetailPage extends StatefulWidget {
  final Map<String, dynamic> quest;

  const QuestDetailPage({super.key, required this.quest});

  @override
  State<QuestDetailPage> createState() => _QuestDetailPageState();
}

class _QuestDetailPageState extends State<QuestDetailPage> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final isDaily = widget.quest['isDaily'] as bool? ?? false;
    final questObject = widget.quest['questObject'];
    final streak = widget.quest['streak'] as int? ?? 0;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Implement edit functionality
            },
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            onPressed: () async {
              await _deleteQuest();
            },
            icon: const Icon(Icons.delete_outline),
          ),
          IconButton(
            onPressed: () {
              // TODO: Implement more options if needed
            },
            icon: const Icon(Icons.more_vert),
          ),
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
                color: _getQuestTypeColor(
                  widget.quest['type'] as String,
                ).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.quest['category'] as String,
                    style: TextStyle(
                      color: _getQuestTypeColor(widget.quest['type'] as String),
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
              widget.quest['title'] as String,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),

            const SizedBox(height: 24),

            // Details cards
            _buildDetailCard(
              icon: Icons.schedule_outlined,
              label: isDaily ? 'Frequency' : 'Due Date',
              value: widget.quest['dueTime'] as String,
              valueColor: (widget.quest['isOverdue'] as bool? ?? false)
                  ? AppTheme.primaryRed
                  : null,
            ),

            const SizedBox(height: 12),

            _buildDetailCard(
              icon: Icons.flag_outlined,
              label: 'Priority',
              value: widget.quest['priority'] as String,
              valueColor: widget.quest['priority'] == 'High'
                  ? AppTheme.primaryRed
                  : null,
            ),

            const SizedBox(height: 12),

            _buildDetailCard(
              icon: Icons.star_outline,
              label: 'Reward',
              value: '${widget.quest['xp']} XP',
              valueColor: Colors.amber[700],
            ),

            if (isDaily && streak > 0) ...[
              const SizedBox(height: 12),
              _buildDetailCard(
                icon: Icons.local_fire_department,
                label: 'Current Streak',
                value: '$streak days',
                valueColor: Colors.orange,
              ),
            ],

            const SizedBox(height: 24),

            // Description section
            Text(
              'Description',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 12),

            Text(
              widget.quest['description'] as String? ??
                  'No description provided.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.6,
                color: AppTheme.textSecondary,
              ),
            ),

            const SizedBox(height: 24),

            // Occurrences or Status for Daily Quests
            if (isDaily) ...[
              Text(
                'Recent Occurrences',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              _buildOccurrencesList(questObject as DailyQuest),
            ],

            const Spacer(),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // TODO: Implement reminder functionality
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
                    onPressed: (widget.quest['isCompleted'] as bool)
                        ? null
                        : () async {
                            await _completeQuest();
                          },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            isDaily && !(widget.quest['isCompleted'] as bool)
                                ? 'Complete Today'
                                : 'Mark as Complete',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                  ),
                ),
              ],
            ),

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

  Widget _buildOccurrencesList(DailyQuest dailyQuest) {
    // Mock data for occurrences - in a real app, this would come from completion history
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final occurrences = <Map<String, dynamic>>[];

    // Generate mock occurrences for the last 5 days or based on frequency
    final daysToShow = dailyQuest.frequency.days * 5;
    for (int i = 0; i < daysToShow; i += dailyQuest.frequency.days) {
      final occurrenceDate = today.subtract(Duration(days: i));
      final isCompleted = i == 0 && _isDailyQuestCompletedToday(dailyQuest);
      occurrences.add({
        'date': occurrenceDate,
        'completed':
            isCompleted || (i > 0 && i < dailyQuest.frequency.days * 3),
      });
    }
    occurrences.sort(
      (a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime),
    );

    if (occurrences.isEmpty) {
      return const Text(
        'No occurrences recorded yet.',
        style: TextStyle(color: AppTheme.textSecondary),
      );
    }

    return Column(
      children: occurrences.take(5).map((occurrence) {
        final date = occurrence['date'] as DateTime;
        final completed = occurrence['completed'] as bool;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: completed ? Colors.green : Colors.transparent,
                  border: Border.all(
                    color: completed ? Colors.green : Colors.grey[400]!,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: completed
                    ? const Icon(Icons.check, color: Colors.white, size: 14)
                    : null,
              ),
              const SizedBox(width: 12),
              Text(
                _formatOccurrenceDate(date),
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  decoration: completed ? TextDecoration.lineThrough : null,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  String _formatOccurrenceDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final occurrenceDate = DateTime(date.year, date.month, date.day);

    if (occurrenceDate == today) {
      return 'Today';
    } else if (occurrenceDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  bool _isDailyQuestCompletedToday(DailyQuest dailyQuest) {
    if (dailyQuest.lastCompletedAt == null) return false;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final completedDate = DateTime(
      dailyQuest.lastCompletedAt!.year,
      dailyQuest.lastCompletedAt!.month,
      dailyQuest.lastCompletedAt!.day,
    );

    return completedDate == today;
  }

  Future<void> _completeQuest() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final isDaily = widget.quest['isDaily'] as bool? ?? false;
      if (isDaily) {
        await DailyQuestService.completeDailyQuest(
          widget.quest['id'] as String,
        );
      } else {
        await QuestService.completeQuest(widget.quest['id'] as String);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Quest completed! +${widget.quest['xp']} XP'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
        Navigator.of(context).pop(true); // Return true to refresh parent page
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error completing quest: $e'),
            backgroundColor: AppTheme.primaryRed,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deleteQuest() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final isDaily = widget.quest['isDaily'] as bool? ?? false;
      if (isDaily) {
        await DailyQuestService.deleteDailyQuest(widget.quest['id'] as String);
      } else {
        await QuestService.deleteQuest(widget.quest['id'] as String);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Quest deleted successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.of(context).pop(true); // Return true to refresh parent page
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting quest: $e'),
            backgroundColor: AppTheme.primaryRed,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
