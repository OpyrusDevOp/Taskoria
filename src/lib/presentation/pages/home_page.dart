import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskoria/core/theme/app_theme.dart';
import 'package:taskoria/data/models/quest.dart';
import 'package:taskoria/presentation/pages/add_quest_page.dart';
import 'package:taskoria/presentation/pages/my_task_page.dart';
import 'package:taskoria/presentation/pages/profile_page.dart';
import 'package:taskoria/presentation/pages/stats_page.dart';
import 'package:taskoria/presentation/providers/quest_provider.dart';
import 'package:taskoria/presentation/providers/user_profile_provider.dart';
import 'package:taskoria/presentation/widgets/category_chip.dart';
import 'package:taskoria/presentation/widgets/profile_header.dart';
import 'package:taskoria/presentation/widgets/quest_card.dart';

import '../../data/models/user_profile.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _currentIndex = 0;
  String _selectedCategory = 'Work 💼';

  @override
  void initState() {
    super.initState();
    // Check for overdue quests when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(questListProvider.notifier).checkOverdueQuests();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProfileDataSourceState = ref.watch(
      userProfileDataSourceFutureProvider,
    );
    final questDataSourceState = ref.watch(questDataSourceFutureProvider);

    return userProfileDataSourceState.when(
      data: (_) {
        return questDataSourceState.when(
          data: (_) {
            final userProfileState = ref.watch(userProfileProvider);
            final questListState = ref.watch(questListProvider);
            return Scaffold(
              body: SafeArea(
                child: _currentIndex == 0
                    ? _buildHomeContent(userProfileState, questListState)
                    : _buildOtherPages(),
              ),
              floatingActionButton: _buildFAB(),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              bottomNavigationBar: _buildBottomNavBar(),
            );
          },
          loading: () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
          error: (error, stack) => Scaffold(
            body: Center(
              child: Text('Error initializing quest data source: $error'),
            ),
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) => Scaffold(
        body: Center(
          child: Text('Error initializing user profile data source: $error'),
        ),
      ),
    );
  }

  Widget _buildHomeContent(
    AsyncValue<UserProfile?> userProfileState,
    AsyncValue<List<Quest>> questListState,
  ) {
    return userProfileState.when(
      data: (profile) {
        if (profile == null) {
          return const Center(child: Text('No user profile found'));
        }
        return questListState.when(
          data: (quests) {
            final filteredQuests = quests
                .where((quest) => quest.category == _selectedCategory)
                .toList();
            return Column(
              children: [
                // Profile Header with real data
                ProfileHeader(userProfile: profile),

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
                              'My Tasks',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    // TODO: Implement list/grid view toggle
                                  },
                                  icon: const Icon(Icons.view_list_outlined),
                                  color: AppTheme.textSecondary,
                                ),
                                IconButton(
                                  onPressed: () {
                                    // TODO: Implement sort
                                  },
                                  icon: const Icon(Icons.tune),
                                  color: AppTheme.textSecondary,
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Categories
                        _buildCategories(),

                        const SizedBox(height: 20),

                        // Quest List
                        Expanded(
                          child: filteredQuests.isEmpty
                              ? _buildEmptyState()
                              : ListView.builder(
                                  itemCount: filteredQuests.length,
                                  itemBuilder: (context, index) {
                                    return QuestCard(
                                      quest: filteredQuests[index],
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) =>
              Center(child: Text('Error loading quests: $error')),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) =>
          Center(child: Text('Error loading profile: $error')),
    );
  }

  Widget _buildCategories() {
    final categories = ['Work 💼', 'Personal 😊', 'Health 💪', 'Learning 📚'];

    return SizedBox(
      height: 40,
      child: ListView.builder(
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
            'No Quests Yet',
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
        gradient: LinearGradient(
          colors: [AppTheme.primaryRed, AppTheme.darkRed],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryRed.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => const AddQuestPage()));
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
            color: Colors.black.withValues(alpha: 0.1),
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
