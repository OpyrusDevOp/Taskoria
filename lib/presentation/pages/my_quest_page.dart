import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utilities/quest_utility.dart';
import '../../models/quest.dart';
import '../../models/enums.dart';
import '../../services/quest_service.dart';
import '../widgets/quest_card.dart';

class MyQuestPage extends StatefulWidget {
  final VoidCallback? onQuestUpdated;

  const MyQuestPage({super.key, this.onQuestUpdated});

  @override
  State<MyQuestPage> createState() => _MyQuestPageState();
}

class _MyQuestPageState extends State<MyQuestPage> {
  String _selectedFilter = 'All';
  String _selectedSort = 'Due Date';
  bool _isGridView = false;
  List<Quest> _quests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuests();
  }

  Future<void> _loadQuests() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final quests = await QuestService.instance.getQuests(limit: 100);
      setState(() {
        _quests = quests;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading quests: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final filteredQuests = _applyFilter(_quests);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('My Quests'),
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
      body: RefreshIndicator(
        onRefresh: _loadQuests,
        child: Padding(
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
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['All', 'Active', 'Completed', 'Failed'];

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
                : _selectedFilter == 'Completed'
                ? 'No completed quests. Keep working on your quests!'
                : 'No failed quests. Great job!',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildListView(List<Quest> quests) {
    return ListView.builder(
      itemCount: quests.length,
      itemBuilder: (context, index) {
        return QuestCard(
          quest: quests[index],
          onQuestUpdated: () {
            _loadQuests();
            widget.onQuestUpdated?.call();
          },
        );
      },
    );
  }

  Widget _buildGridView(List<Quest> quests) {
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
                // Quest Type badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: QuestUtility.getQuestTypeColor(
                      quest.type,
                    ).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    QuestUtility.getQuestTypeDisplayName(quest.type),
                    style: TextStyle(
                      color: QuestUtility.getQuestTypeColor(quest.type),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Title
                Text(
                  quest.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    decoration: quest.status == QuestStatus.completed
                        ? TextDecoration.lineThrough
                        : null,
                    color: quest.status == QuestStatus.completed
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
                        QuestUtility.formatDueTime(quest.dueTime),
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(Icons.star, size: 14, color: Colors.amber),
                    Text(
                      '${quest.reward}',
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

  List<Quest> _applyFilter(List<Quest> quests) {
    List<Quest> filtered;
    if (_selectedFilter == 'All') {
      filtered = quests;
    } else if (_selectedFilter == 'Active') {
      filtered = quests.where((q) => q.status == QuestStatus.pending).toList();
    } else if (_selectedFilter == 'Completed') {
      filtered = quests
          .where((q) => q.status == QuestStatus.completed)
          .toList();
    } else {
      // Failed
      filtered = quests.where((q) => q.status == QuestStatus.failed).toList();
    }

    // Apply sorting
    switch (_selectedSort) {
      case 'Due Date':
        filtered.sort((a, b) => a.dueTime.compareTo(b.dueTime));
        break;
      case 'Priority':
        filtered.sort(
          (a, b) =>
              _getPriorityValue(b.type).compareTo(_getPriorityValue(a.type)),
        );
        break;
      case 'XP Reward':
        filtered.sort((a, b) => b.reward.compareTo(a.reward));
        break;
      case 'Title (A-Z)':
        filtered.sort((a, b) => a.title.compareTo(b.title));
        break;
    }

    return filtered;
  }

  int _getPriorityValue(QuestType type) {
    switch (type) {
      case QuestType.urgent:
        return 3;
      case QuestType.main:
        return 2;
      case QuestType.event:
        return 2;
      case QuestType.side:
        return 1;
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
}
