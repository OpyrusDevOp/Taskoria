import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utilities/quest_utility.dart';
import '../../models/quest.dart';
import '../../models/enums.dart';
import '../../services/quest_service.dart';
import '../widgets/category_chip.dart';
import '../widgets/profile_header.dart';
import '../widgets/quest_card.dart';
import 'add_quest_page.dart';
import 'my_quest_page.dart';
import 'profile_page.dart';
import 'stats_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  QuestType _selectedQuestType = QuestType.main;
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
      final quests = await QuestService.instance.getOnGoingQuest(limit: 10);
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
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final filteredQuests = _quests.where((quest) {
      return quest.type == _selectedQuestType;
    }).toList();

    return Column(
      children: [
        // Profile Header
        const ProfileHeader(),

        // Content
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'My Quests',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: _loadQuests,
                          icon: const Icon(Icons.refresh_outlined),
                          color: AppTheme.textSecondary,
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.tune),
                          color: AppTheme.textSecondary,
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Quest Type Filters
                _buildQuestTypeFilters(),

                const SizedBox(height: 20),

                // Quest List
                Expanded(
                  child: filteredQuests.isEmpty
                      ? _buildEmptyState()
                      : RefreshIndicator(
                          onRefresh: _loadQuests,
                          child: ListView.builder(
                            itemCount: filteredQuests.length,
                            itemBuilder: (context, index) {
                              return QuestCard(
                                quest: filteredQuests[index],
                                onQuestUpdated: _loadQuests,
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestTypeFilters() {
    final questTypes = QuestType.values;

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: questTypes.length,
        itemBuilder: (context, index) {
          final questType = questTypes[index];
          return Padding(
            padding: EdgeInsets.only(
              right: index < questTypes.length - 1 ? 12 : 0,
            ),
            child: CategoryChip(
              label: QuestUtility.getQuestTypeDisplayName(questType),
              isSelected: questType == _selectedQuestType,
              onTap: () {
                setState(() {
                  _selectedQuestType = questType;
                });
              },
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
              color: AppTheme.lightRed.withOpacity(0.3),
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
            'No ${QuestUtility.getQuestTypeDisplayName(_selectedQuestType)}s Yet',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to create your first quest!',
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
        return MyQuestPage(onQuestUpdated: _loadQuests);
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
        gradient: LinearGradient(
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
          if (result == true) {
            _loadQuests(); // Refresh quests after adding new one
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

