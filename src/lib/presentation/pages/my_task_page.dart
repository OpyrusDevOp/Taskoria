import 'package:flutter/material.dart';
import 'package:taskoria/core/theme/app_theme.dart';
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

  // Mock data for design (same as HomePage for consistency)
  final List<Map<String, dynamic>> _mockQuests = [
    {
      'title': 'Finish UI Project Report',
      'category': 'Work 💼',
      'priority': 'High',
      'dueTime': 'Today, 5 PM',
      'xp': 20,
      'isCompleted': false,
      'type': 'main',
    },
    {
      'title': 'Design Shot',
      'category': 'Work 💼',
      'priority': 'Medium',
      'dueTime': 'Tomorrow',
      'xp': 20,
      'isCompleted': true,
      'type': 'side',
    },
    {
      'title': 'Daily Workout',
      'category': 'Personal 😊',
      'priority': 'Low',
      'dueTime': 'Today',
      'xp': 15,
      'isCompleted': false,
      'type': 'recurrent',
    },
    {
      'title': 'Grocery Shopping',
      'category': 'Personal 😊',
      'priority': 'Medium',
      'dueTime': 'This Weekend',
      'xp': 10,
      'isCompleted': false,
      'type': 'side',
    },
    {
      'title': 'Team Meeting',
      'category': 'Work 💼',
      'priority': 'High',
      'dueTime': 'Today, 2 PM',
      'xp': 30,
      'isCompleted': false,
      'type': 'urgent',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Apply filter to mock data
    final filteredQuests = _applyFilter(_mockQuests);

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

            // Quest List or Grid
            Expanded(
              child: filteredQuests.isEmpty
                  ? _buildEmptyState()
                  : _isGridView
                  ? _buildGridView(filteredQuests)
                  : _buildListView(filteredQuests),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['All', 'Active', 'Completed'];

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
            'No Quests Found',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _selectedFilter == 'All'
                ? 'Tap the + button to create your first quest!'
                : _selectedFilter == 'Active'
                ? 'No active quests. Mark some as incomplete or create new ones!'
                : 'No completed quests. Keep working on your tasks!',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildListView(List<Map<String, dynamic>> quests) {
    return ListView.builder(
      itemCount: quests.length,
      itemBuilder: (context, index) {
        return QuestCard(quest: quests[index]);
      },
    );
  }

  Widget _buildGridView(List<Map<String, dynamic>> quests) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: quests.length,
      itemBuilder: (context, index) {
        final quest = quests[index];
        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: Colors.grey.withValues(alpha: 0.1),
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
                      quest['type'] as String,
                    ).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    quest['category'] as String,
                    style: TextStyle(
                      color: _getQuestTypeColor(quest['type'] as String),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Title
                Text(
                  quest['title'] as String,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    decoration: (quest['isCompleted'] as bool)
                        ? TextDecoration.lineThrough
                        : null,
                    color: (quest['isCompleted'] as bool)
                        ? AppTheme.textSecondary
                        : AppTheme.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                // Details
                Row(
                  children: [
                    Icon(
                      Icons.schedule_outlined,
                      size: 14,
                      color: AppTheme.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        quest['dueTime'] as String,
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(Icons.star, size: 14, color: Colors.amber),
                    Text(
                      '${quest['xp']}',
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

  List<Map<String, dynamic>> _applyFilter(List<Map<String, dynamic>> quests) {
    if (_selectedFilter == 'All') {
      return quests;
    } else if (_selectedFilter == 'Active') {
      return quests.where((q) => !(q['isCompleted'] as bool)).toList();
    } else {
      return quests.where((q) => q['isCompleted'] as bool).toList();
    }
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
