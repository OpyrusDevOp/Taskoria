import 'package:flutter/material.dart';
import 'package:taskoria/core/theme/app_theme.dart';
import 'package:taskoria/models/quest.dart';
import 'package:taskoria/models/daily_quest.dart';
import 'package:taskoria/models/enums.dart';
import 'package:taskoria/services/quest_service.dart';
import 'package:taskoria/services/daily_quest_service.dart';
import 'package:taskoria/services/streak_service.dart';
import 'package:taskoria/presentation/widgets/quest_card.dart';

class MyTaskPage extends StatefulWidget {
  const MyTaskPage({super.key});

  @override
  State<MyTaskPage> createState() => _MyTaskPageState();
}

class _MyTaskPageState extends State<MyTaskPage> {
  String _selectedFilter = 'All';
  String _selectedSort = 'Due Date';
  bool _isGridView = false;
  bool _isLoading = true;

  List<Quest> _quests = [];
  List<DailyQuest> _dailyQuests = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final quests = QuestService.getAllQuests();
      final dailyQuests = DailyQuestService.getAllDailyQuests();

      setState(() {
        _quests = quests;
        _dailyQuests = dailyQuests;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading tasks: $e'),
            backgroundColor: AppTheme.primaryRed,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Apply filter to quests and daily quests
    final filteredTasks = _applyFilter(_quests, _dailyQuests);
    final sortedTasks = _applySort(filteredTasks);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('My Tasks'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
            icon: Icon(
              _isGridView ? Icons.view_list_outlined : Icons.grid_view_outlined,
              color: AppTheme.textSecondary,
            ),
          ),
          IconButton(
            onPressed: _showSortOptions,
            icon: const Icon(
              Icons.sort_outlined,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter Chips
            _buildFilterChips(),
            const SizedBox(height: 16),

            // Task List or Grid
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.primaryRed,
                      ),
                    )
                  : sortedTasks.isEmpty
                  ? _buildEmptyState()
                  : _isGridView
                  ? _buildGridView(sortedTasks)
                  : _buildListView(sortedTasks),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['All', 'Active', 'Completed', 'Overdue', 'Daily'];

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          return Padding(
            padding: EdgeInsets.only(
              right: index < filters.length - 1 ? 12 : 0,
            ),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: _selectedFilter == filter
                      ? AppTheme.primaryRed
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _selectedFilter == filter
                        ? AppTheme.primaryRed
                        : Colors.grey[300]!,
                    width: 1,
                  ),
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    color: _selectedFilter == filter
                        ? Colors.white
                        : AppTheme.textSecondary,
                    fontSize: 14,
                    fontWeight: _selectedFilter == filter
                        ? FontWeight.w600
                        : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppTheme.lightRed.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.assignment_outlined,
              size: 60,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Tasks Found',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _getEmptyStateMessage(),
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getEmptyStateMessage() {
    switch (_selectedFilter) {
      case 'All':
        return 'Tap the + button to create your first task!';
      case 'Active':
        return 'No active tasks. Mark some as incomplete or create new ones!';
      case 'Completed':
        return 'No completed tasks. Keep working on your tasks!';
      case 'Overdue':
        return 'No overdue tasks. Great job staying on top of things!';
      case 'Daily':
        return 'No daily tasks. Add recurring tasks to build habits!';
      default:
        return 'No tasks found.';
    }
  }

  Widget _buildListView(List<Map<String, dynamic>> tasks) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return QuestCard(
          quest: tasks[index],
          onComplete: _handleTaskComplete,
          onRefresh: _loadData,
        );
      },
    );
  }

  Widget _buildGridView(List<Map<String, dynamic>> tasks) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        final isDaily = task['isDaily'] as bool? ?? false;
        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: (task['isOverdue'] as bool? ?? false)
                  ? AppTheme.primaryRed.withValues(alpha: 0.3)
                  : Colors.grey.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getQuestTypeColor(
                      task['type'] as String,
                    ).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    task['category'] as String,
                    style: TextStyle(
                      color: _getQuestTypeColor(task['type'] as String),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Title
                Text(
                  task['title'] as String,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    decoration: (task['isCompleted'] as bool)
                        ? TextDecoration.lineThrough
                        : null,
                    color: (task['isCompleted'] as bool)
                        ? AppTheme.textSecondary
                        : (task['isOverdue'] as bool? ?? false)
                        ? AppTheme.primaryRed
                        : AppTheme.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (isDaily && (task['streak'] as int? ?? 0) > 0) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.local_fire_department,
                        size: 14,
                        color: Colors.orange,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${task['streak']}',
                        style: const TextStyle(
                          color: Colors.orange,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
                const Spacer(),
                // Details
                Row(
                  children: [
                    Icon(
                      (task['isOverdue'] as bool? ?? false)
                          ? Icons.warning_outlined
                          : Icons.schedule_outlined,
                      size: 14,
                      color: (task['isOverdue'] as bool? ?? false)
                          ? AppTheme.primaryRed
                          : AppTheme.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        task['dueTime'] as String,
                        style: TextStyle(
                          color: (task['isOverdue'] as bool? ?? false)
                              ? AppTheme.primaryRed
                              : AppTheme.textSecondary,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(Icons.star, size: 14, color: Colors.amber),
                    Text(
                      '${task['xp']}',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Map<String, dynamic>> _applyFilter(
    List<Quest> quests,
    List<DailyQuest> dailyQuests,
  ) {
    final tasks = <Map<String, dynamic>>[];

    // Add regular quests
    for (final quest in quests) {
      tasks.add(_questToMap(quest));
    }

    // Add daily quests (not occurrences, just the base task)
    for (final dailyQuest in dailyQuests) {
      tasks.add(_dailyQuestToMap(dailyQuest));
    }

    // Apply filter
    if (_selectedFilter == 'All') {
      return tasks;
    } else if (_selectedFilter == 'Active') {
      return tasks.where((t) => !(t['isCompleted'] as bool)).toList();
    } else if (_selectedFilter == 'Completed') {
      return tasks.where((t) => t['isCompleted'] as bool).toList();
    } else if (_selectedFilter == 'Overdue') {
      return tasks.where((t) => t['isOverdue'] as bool? ?? false).toList();
    } else if (_selectedFilter == 'Daily') {
      return tasks.where((t) => t['isDaily'] as bool? ?? false).toList();
    }
    return tasks;
  }

  List<Map<String, dynamic>> _applySort(List<Map<String, dynamic>> tasks) {
    final sortedTasks = List<Map<String, dynamic>>.from(tasks);

    if (_selectedSort == 'Due Date') {
      sortedTasks.sort((a, b) {
        if (a['isCompleted'] != b['isCompleted']) {
          return a['isCompleted'] ? 1 : -1;
        }
        if (a['isOverdue'] != b['isOverdue']) {
          return a['isOverdue'] ? -1 : 1;
        }
        return 0; // TODO: Add actual due date comparison when available
      });
    } else if (_selectedSort == 'Priority') {
      sortedTasks.sort((a, b) {
        if (a['isCompleted'] != b['isCompleted']) {
          return a['isCompleted'] ? 1 : -1;
        }
        final priorityOrder = {'High': 0, 'Medium': 1, 'Low': 2};
        final aPriority = priorityOrder[a['priority']] ?? 3;
        final bPriority = priorityOrder[b['priority']] ?? 3;
        return aPriority.compareTo(bPriority);
      });
    } else if (_selectedSort == 'XP Reward') {
      sortedTasks.sort((a, b) {
        if (a['isCompleted'] != b['isCompleted']) {
          return a['isCompleted'] ? 1 : -1;
        }
        return (b['xp'] as int).compareTo(a['xp'] as int);
      });
    } else if (_selectedSort == 'Title (A-Z)') {
      sortedTasks.sort((a, b) {
        if (a['isCompleted'] != b['isCompleted']) {
          return a['isCompleted'] ? 1 : -1;
        }
        return (a['title'] as String).compareTo(b['title'] as String);
      });
    }

    return sortedTasks;
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sort By',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildSortOption('Due Date'),
              _buildSortOption('Priority'),
              _buildSortOption('XP Reward'),
              _buildSortOption('Title (A-Z)'),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSortOption(String option) {
    final isSelected = _selectedSort == option;
    return ListTile(
      title: Text(option),
      trailing: isSelected
          ? Icon(Icons.check, color: AppTheme.primaryRed)
          : null,
      onTap: () {
        setState(() {
          _selectedSort = option;
        });
        Navigator.pop(context);
      },
    );
  }

  Map<String, dynamic> _questToMap(Quest quest) {
    return {
      'id': quest.id,
      'title': quest.title,
      'description': quest.description,
      'category': _getQuestTypeDisplayName(quest.type),
      'priority': _getQuestPriority(quest.importance),
      'dueTime': _formatDueTime(quest.dueDateTime),
      'xp': _calculateDisplayXP(quest),
      'isCompleted': quest.status == QuestStatus.completed,
      'isOverdue': quest.status == QuestStatus.overdue,
      'type': quest.type.name,
      'isDaily': false,
      'questObject': quest,
    };
  }

  Map<String, dynamic> _dailyQuestToMap(DailyQuest dailyQuest) {
    return {
      'id': dailyQuest.id,
      'title': dailyQuest.title,
      'description': dailyQuest.description,
      'category': _getQuestTypeDisplayName(dailyQuest.type),
      'priority': _getQuestPriority(dailyQuest.importance),
      'dueTime': _getFrequencyDisplay(dailyQuest.frequency),
      'xp': _calculateDailyQuestDisplayXP(dailyQuest),
      'isCompleted': false, // Daily quests show as incomplete in list
      'isOverdue': false,
      'type': dailyQuest.type.name,
      'isDaily': true,
      'questObject': dailyQuest,
      'streak': _getDailyQuestStreak(dailyQuest),
    };
  }

  String _getQuestTypeDisplayName(QuestType type) {
    switch (type) {
      case QuestType.mainQuest:
        return 'Main Quest ⚔️';
      case QuestType.sideQuest:
        return 'Side Quest 🗡️';
      case QuestType.urgentQuest:
        return 'Urgent Quest ⚡';
      case QuestType.challenge:
        return 'Challenge 🏆';
      case QuestType.specialEvent:
        return 'Special Event 🎉';
    }
  }

  String _getQuestPriority(int importance) {
    if (importance >= 4) return 'High';
    if (importance >= 3) return 'Medium';
    return 'Low';
  }

  String _formatDueTime(DateTime? dueDateTime) {
    if (dueDateTime == null) return 'No due date';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDate = DateTime(
      dueDateTime.year,
      dueDateTime.month,
      dueDateTime.day,
    );

    if (dueDate == today) {
      return 'Today, ${_formatTime(dueDateTime)}';
    } else if (dueDate == today.add(const Duration(days: 1))) {
      return 'Tomorrow, ${_formatTime(dueDateTime)}';
    } else if (dueDate.isBefore(today)) {
      return 'Overdue';
    } else {
      final difference = dueDate.difference(today).inDays;
      return 'In $difference days';
    }
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
  }

  String _getFrequencyDisplay(QuestFrequency frequency) {
    switch (frequency) {
      case QuestFrequency.daily:
        return 'Daily';
      case QuestFrequency.every2Days:
        return 'Every 2 Days';
      case QuestFrequency.every3Days:
        return 'Every 3 Days';
      case QuestFrequency.every4Days:
        return 'Every 4 Days';
      case QuestFrequency.every5Days:
        return 'Every 5 Days';
      case QuestFrequency.every6Days:
        return 'Every 6 Days';
      case QuestFrequency.weekly:
        return 'Weekly';
    }
  }

  int _calculateDisplayXP(Quest quest) {
    // Simplified XP calculation for display
    const baseValues = {
      QuestType.mainQuest: 50,
      QuestType.challenge: 10,
      QuestType.sideQuest: 30,
      QuestType.urgentQuest: 60,
      QuestType.specialEvent: 100,
    };
    final baseXP = quest.baseXP > 0
        ? quest.baseXP
        : (baseValues[quest.type] ?? 30);
    return (baseXP * (quest.importance / 3.0)).round();
  }

  int _calculateDailyQuestDisplayXP(DailyQuest dailyQuest) {
    // Simplified XP calculation for display
    const baseValues = {
      QuestType.mainQuest: 50,
      QuestType.challenge: 10,
      QuestType.sideQuest: 30,
      QuestType.urgentQuest: 60,
      QuestType.specialEvent: 100,
    };
    final baseXP = dailyQuest.baseXP > 0
        ? dailyQuest.baseXP
        : (baseValues[dailyQuest.type] ?? 30);
    return (baseXP * (dailyQuest.importance / 3.0)).round();
  }

  int _getDailyQuestStreak(DailyQuest dailyQuest) {
    try {
      final streak = StreakService.getStreak(dailyQuest.id);
      return streak?.currentStreak ?? 0;
    } catch (e) {
      return 0;
    }
  }

  Future<void> _handleTaskComplete(Map<String, dynamic> taskData) async {
    try {
      if (taskData['isDaily'] == true) {
        await DailyQuestService.completeDailyQuest(taskData['id']);
      } else {
        await QuestService.completeQuest(taskData['id']);
      }
      await _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Task completed! +${taskData['xp']} XP'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error completing task: $e'),
            backgroundColor: AppTheme.primaryRed,
          ),
        );
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

