import 'package:flutter/material.dart';
import 'package:taskoria/core/theme/app_theme.dart';
import 'package:taskoria/models/extensions.dart';
import 'package:taskoria/models/quest.dart';
import 'package:taskoria/models/daily_quest.dart';
import 'package:taskoria/models/enums.dart';
import 'package:taskoria/services/quest_service.dart';
import 'package:taskoria/services/daily_quest_service.dart';
import 'package:taskoria/services/user_service.dart';
import 'package:taskoria/services/streak_service.dart';
import 'package:taskoria/presentation/pages/my_task_page.dart';
import 'package:taskoria/presentation/widgets/profile_header.dart';
import 'package:taskoria/presentation/widgets/quest_card.dart';
import 'package:taskoria/presentation/widgets/category_chip.dart';
import 'package:taskoria/presentation/pages/add_quest_page.dart';
import 'package:taskoria/presentation/pages/profile_page.dart';
import 'package:taskoria/presentation/pages/stats_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  String _selectedCategory = 'All';

  List<Quest> _todayQuests = [];
  List<DailyQuest> _todayDailyQuests = [];
  bool _isLoading = true;

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
      // Load quests due today (including completed)
      final allQuests = QuestService.getAllQuests();
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day, 23, 59, 59);
      final questsDueToday = allQuests.where((quest) {
        if (quest.dueDateTime == null) return false;
        return !quest.dueDateTime!.isAfter(today);
      }).toList();

      // Load active daily quests and filter by frequency/weekday
      final activeDailyQuests = DailyQuestService.getActiveDailyQuests();
      final todayDailyQuests = activeDailyQuests.where((dailyQuest) {
        return _isDailyQuestValidToday(dailyQuest, now);
      }).toList();

      setState(() {
        _todayQuests = questsDueToday;
        _todayDailyQuests = todayDailyQuests;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading data: $e'),
            backgroundColor: AppTheme.primaryRed,
          ),
        );
      }
    }
  }

  bool _isDailyQuestValidToday(DailyQuest dailyQuest, DateTime now) {
    // Check if today matches the frequency and start weekday
    final startDate = dailyQuest.startDate;
    final startWeekday = dailyQuest.startWeekday;
    final frequencyDays = dailyQuest.frequency.days;
    final todayWeekday = now.weekday;

    // Calculate if today is a valid occurrence day based on start day and frequency
    final daysSinceStart = now.difference(startDate).inDays;
    final isValidDay = daysSinceStart % frequencyDays == 0;

    // For weekly frequency, also check if today matches the start weekday
    if (dailyQuest.frequency == QuestFrequency.weekly) {
      return isValidDay && todayWeekday == startWeekday;
    }

    return isValidDay;
  }

  Future<void> _refreshData() async {
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _currentIndex == 0 ? _buildHomeContent() : _buildOtherPages(),
      ),
      floatingActionButton: _currentIndex == 0 ? _buildFAB() : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildHomeContent() {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: CustomScrollView(
        slivers: [
          // Profile Header
          const SliverToBoxAdapter(child: ProfileHeader()),

          // Today's Tasks Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Today\'s Tasks',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: _refreshData,
                        icon: const Icon(Icons.refresh_outlined),
                        color: AppTheme.textSecondary,
                      ),
                      IconButton(
                        onPressed: () {
                          // TODO: Add filter/sort options
                        },
                        icon: const Icon(Icons.tune),
                        color: AppTheme.textSecondary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Categories
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(height: 40, child: _buildCategories()),
            ),
          ),

          // Daily Quests Section
          if (_todayDailyQuests.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Daily Quests',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _currentIndex = 2; // Navigate to MyTaskPage
                            });
                          },
                          child: Text(
                            'See All',
                            style: TextStyle(
                              color: AppTheme.primaryRed,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 120, // Fixed height for daily quests section
                      child: _buildDailyQuestList(),
                    ),
                  ],
                ),
              ),
            ),

          // Regular Quests List
          _isLoading
              ? const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 50),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.primaryRed,
                      ),
                    ),
                  ),
                )
              : (_todayQuests.isEmpty && _todayDailyQuests.isEmpty)
              ? SliverToBoxAdapter(child: _buildEmptyState())
              : SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final filteredQuests = _getFilteredQuests();
                      // Sort by priority and due date
                      final questItems = <Map<String, dynamic>>[];
                      for (final quest in filteredQuests) {
                        questItems.add(_questToMap(quest));
                      }
                      questItems.sort((a, b) {
                        // Completed items go to bottom
                        if (a['isCompleted'] != b['isCompleted']) {
                          return a['isCompleted'] ? 1 : -1;
                        }
                        // Overdue items go to top
                        if (a['isOverdue'] != b['isOverdue']) {
                          return a['isOverdue'] ? -1 : 1;
                        }
                        // Then by priority
                        final priorityOrder = {
                          'High': 0,
                          'Medium': 1,
                          'Low': 2,
                        };
                        final aPriority = priorityOrder[a['priority']] ?? 3;
                        final bPriority = priorityOrder[b['priority']] ?? 3;
                        return aPriority.compareTo(bPriority);
                      });
                      return QuestCard(
                        quest: questItems[index],
                        onComplete: _handleQuestComplete,
                        onRefresh: _refreshData,
                      );
                    }, childCount: _getFilteredQuests().length),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    final categories = _getAvailableCategories();

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return Padding(
          padding: EdgeInsets.only(
            right: index < categories.length - 1 ? 12 : 0,
          ),
          child: CategoryChip(
            label: category,
            isSelected: category == _selectedCategory,
            onTap: () {
              setState(() {
                _selectedCategory = category;
              });
            },
          ),
        );
      },
    );
  }

  List<String> _getAvailableCategories() {
    final categories = <String>{'All'};

    // Add categories from quest types for today quests
    for (final quest in _todayQuests) {
      categories.add(_getQuestTypeDisplayName(quest.type));
    }

    return categories.toList();
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

  Widget _buildDailyQuestList() {
    final completableDaily = _todayDailyQuests.where((dailyQuest) {
      // Only show if not completed today
      return !_isDailyQuestCompletedToday(dailyQuest);
    }).toList();

    if (completableDaily.isEmpty && _todayDailyQuests.isNotEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.lightRed.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.lightRed.withOpacity(0.3)),
        ),
        child: const Text(
          'All daily quests completed for today! Great job!',
          style: TextStyle(
            color: AppTheme.primaryRed,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    } else if (completableDaily.isEmpty) {
      return const SizedBox.shrink();
    }

    // Show only completable daily quests for today
    final dailyQuestItems = <Map<String, dynamic>>[];
    for (final dailyQuest in completableDaily) {
      dailyQuestItems.add(_dailyQuestToMap(dailyQuest));
    }

    // Sort by importance
    dailyQuestItems.sort((a, b) {
      final priorityOrder = {'High': 0, 'Medium': 1, 'Low': 2};
      final aPriority = priorityOrder[a['priority']] ?? 3;
      final bPriority = priorityOrder[b['priority']] ?? 3;
      return aPriority.compareTo(bPriority);
    });

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: dailyQuestItems.length,
      itemBuilder: (context, index) {
        return Container(
          width: 300, // Fixed width for each card
          margin: EdgeInsets.only(
            right: index < dailyQuestItems.length - 1 ? 12 : 0,
          ),
          child: QuestCard(
            quest: dailyQuestItems[index],
            onComplete: _handleQuestComplete,
            onRefresh: _refreshData,
          ),
        );
      },
    );
  }

  List<Quest> _getFilteredQuests() {
    if (_selectedCategory == 'All') {
      return _todayQuests;
    }

    return _todayQuests.where((quest) {
      return _getQuestTypeDisplayName(quest.type) == _selectedCategory;
    }).toList();
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
      'dueTime': 'Today',
      'xp': _calculateDailyQuestDisplayXP(dailyQuest),
      'isCompleted': _isDailyQuestCompletedToday(dailyQuest),
      'isOverdue': false,
      'type': dailyQuest.type.name,
      'isDaily': true,
      'questObject': dailyQuest,
      'streak': _getDailyQuestStreak(dailyQuest),
    };
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

  int _calculateDisplayXP(Quest quest) {
    final userProfile = UserService.getCurrentProfile();
    return quest.baseXP > 0
        ? quest.baseXP
        : _getBaseXPForType(
            quest.type,
            quest.importance,
            userProfile.currentLevel,
          );
  }

  int _calculateDailyQuestDisplayXP(DailyQuest dailyQuest) {
    final userProfile = UserService.getCurrentProfile();
    return dailyQuest.baseXP > 0
        ? dailyQuest.baseXP
        : _getBaseXPForType(
            dailyQuest.type,
            dailyQuest.importance,
            userProfile.currentLevel,
          );
  }

  int _getBaseXPForType(QuestType type, int importance, int userLevel) {
    // Use XPService logic but simplified for display
    const baseValues = {
      QuestType.mainQuest: 50,
      QuestType.challenge: 10,
      QuestType.sideQuest: 30,
      QuestType.urgentQuest: 60,
      QuestType.specialEvent: 100,
    };

    final baseXP = baseValues[type] ?? 30;
    final importanceMultiplier = importance / 3.0;
    final levelMultiplier = 1 + (0.1 * userLevel);

    return (baseXP * importanceMultiplier * levelMultiplier).round();
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

  int _getDailyQuestStreak(DailyQuest dailyQuest) {
    // Get streak from StreakService
    try {
      final streak = StreakService.getStreak(dailyQuest.id);
      return streak?.currentStreak ?? 0;
    } catch (e) {
      return 0;
    }
  }

  Future<void> _handleQuestComplete(Map<String, dynamic> questData) async {
    try {
      if (questData['isDaily'] == true) {
        // Complete daily quest
        await DailyQuestService.completeDailyQuest(questData['id']);
      } else {
        // Complete regular quest
        await QuestService.completeQuest(questData['id']);
      }

      // Refresh data
      await _refreshData();

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Quest completed! +${questData['xp']} XP'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
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
    }
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppTheme.lightRed.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.assignment_outlined,
              size: 60,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Tasks for Today',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to create a new quest or check My Tasks for all tasks!',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildOtherPages() {
    switch (_currentIndex) {
      case 1:
        return const StatsPage();
      case 2:
        return const MyTaskPage();
      case 3:
        return const ProfilePage();
      default:
        return const SizedBox();
    }
  }

  Widget _buildFAB() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryRed, AppTheme.darkRed],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryRed.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => const AddQuestPage()));

          // Refresh data if a quest was added
          if (result == true) {
            await _refreshData();
          }
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home_filled, 'Home', 0),
          _buildNavItem(Icons.bar_chart_rounded, 'Stats', 1),
          const SizedBox(width: 60), // Space for FAB
          _buildNavItem(Icons.list_alt_rounded, 'My Task', 2),
          _buildNavItem(Icons.person_rounded, 'Profile', 3),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.primaryRed : AppTheme.textSecondary,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? AppTheme.primaryRed
                    : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
