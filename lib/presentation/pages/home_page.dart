import 'package:flutter/material.dart';
import 'package:taskoria/core/theme/app_theme.dart';
import 'package:taskoria/models/quest.dart';
import 'package:taskoria/models/challenge_occurrence.dart';
import 'package:taskoria/models/enums.dart';
import 'package:taskoria/services/quest_service.dart';
import 'package:taskoria/services/challenge_occurrence_service.dart';
import 'package:taskoria/presentation/widgets/profile_header.dart';
import 'package:taskoria/presentation/widgets/quest_card.dart';
import 'package:taskoria/presentation/widgets/category_chip.dart';
import 'package:taskoria/presentation/pages/add_quest_page.dart';

import '../../services/main_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  String _selectedCategory = 'All';

  List<Quest> _todayQuests = [];
  List<ChallengeOccurrence> _todayChallenges = [];
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
      // Load today's quests (pending, not completed/failed/overdue)
      final questsDueToday = await AdventureService.getTodayActiveQuests();
      // Load today's challenge occurrences (pending)
      final todayChallenges = await AdventureService.getTodayActiveChallenges();
      setState(() {
        _todayQuests = questsDueToday;
        _todayChallenges = todayChallenges;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading quests: $e'),
            backgroundColor: AppTheme.primaryRed,
          ),
        );
      }
    }
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
          SliverToBoxAdapter(child: ProfileHeader()),

          // Today's Quests Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Today\'s Quests',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  IconButton(
                    onPressed: _refreshData,
                    icon: const Icon(Icons.refresh_outlined),
                    color: AppTheme.textSecondary,
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

          // Challenge of the Day Section
          if (_todayChallenges.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Challenge of the Day',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(height: 120, child: _buildChallengeList()),
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
              : (_getFilteredQuests().isEmpty &&
                    _getFilteredChallenges().isEmpty)
              ? SliverToBoxAdapter(child: _buildEmptyState())
              : SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final filteredQuests = _getFilteredQuests();
                        final filteredChallenges = _getFilteredChallenges();
                        final allItems = [
                          ...filteredQuests.map(_questToMap),
                          ...filteredChallenges.map(_challengeToMap),
                        ];

                        // Sort: Overdue first, then by due date
                        allItems.sort((a, b) {
                          if (a['isOverdue'] != b['isOverdue']) {
                            return a['isOverdue'] ? -1 : 1;
                          }
                          final aDue = a['dueTimeSort'] as DateTime?;
                          final bDue = b['dueTimeSort'] as DateTime?;
                          if (aDue != null && bDue != null) {
                            return aDue.compareTo(bDue);
                          }
                          return 0;
                        });

                        return QuestCard(
                          quest: allItems[index],
                          onComplete: _handleQuestComplete,
                          onRefresh: _refreshData,
                        );
                      },
                      childCount:
                          _getFilteredQuests().length +
                          _getFilteredChallenges().length,
                    ),
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

    for (final quest in _todayQuests) {
      categories.add(_getQuestTypeDisplayName(quest.type));
    }
    for (final _ in _todayChallenges) {
      categories.add('Challenge 🏆');
      break;
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

  Widget _buildChallengeList() {
    final completableChallenges = _todayChallenges.where((occ) {
      return occ.completedAt == null;
    }).toList();

    if (completableChallenges.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.lightRed.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.lightRed.withOpacity(0.3)),
        ),
        child: const Text(
          'All challenges completed for today! Great job!',
          style: TextStyle(
            color: AppTheme.primaryRed,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    final challengeItems = completableChallenges.map(_challengeToMap).toList();

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: challengeItems.length,
      itemBuilder: (context, index) {
        return Container(
          width: 300,
          margin: EdgeInsets.only(
            right: index < challengeItems.length - 1 ? 12 : 0,
          ),
          child: QuestCard(
            quest: challengeItems[index],
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

  List<ChallengeOccurrence> _getFilteredChallenges() {
    if (_selectedCategory == 'All' || _selectedCategory == 'Challenge 🏆') {
      return _todayChallenges;
    }
    return [];
  }

  Map<String, dynamic> _questToMap(Quest quest) {
    return {
      'id': quest.id,
      'title': quest.title,
      'description': quest.description,
      'category': _getQuestTypeDisplayName(quest.type),
      'priority': _getQuestPriority(quest.type),
      'dueTime': _formatDueTime(quest.dueDateTime),
      'dueTimeSort': quest.dueDateTime,
      'xp': quest.reward,
      'isCompleted': quest.status == QuestStatus.completed,
      'isOverdue': quest.status == QuestStatus.overdue,
      'type': quest.type.name,
      'isDaily': false,
      'questObject': quest,
    };
  }

  Map<String, dynamic> _challengeToMap(ChallengeOccurrence occ) {
    return {
      'id': occ.id,
      'title': 'Challenge of the Day',
      'description': 'Complete your daily challenge!',
      'category': 'Challenge 🏆',
      'priority': 'High',
      'dueTime': 'Today',
      'dueTimeSort': occ.dateInstance,
      'xp': occ.reward,
      'isCompleted': occ.completedAt != null,
      'isOverdue': false,
      'type': 'challenge',
      'isDaily': false,
      'questObject': occ,
    };
  }

  String _getQuestPriority(QuestType type) {
    switch (type) {
      case QuestType.urgentQuest:
        return 'High';
      case QuestType.mainQuest:
      case QuestType.specialEvent:
      case QuestType.challenge:
        return 'Medium';
      case QuestType.sideQuest:
        return 'Low';
    }
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

  Future<void> _handleQuestComplete(Map<String, dynamic> questData) async {
    try {
      if (questData['type'] == 'challenge') {
        // Complete challenge occurrence
        await ChallengeOccurrenceService.completeOccurrence(
          questData['id'],
          DateTime.now(),
        );
      } else {
        // Complete regular quest
        await QuestService.completeQuest(questData['id'], DateTime.now());
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
            'No Quests for Today',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to create a new quest!',
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
    // Replace with your other pages (Stats, My Quests, Profile, etc.)
    return const SizedBox();
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
          _buildNavItem(Icons.list_alt_rounded, 'My Quests', 2),
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

