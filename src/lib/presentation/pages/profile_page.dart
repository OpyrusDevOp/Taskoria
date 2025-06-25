import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskoria/core/theme/app_theme.dart';
import 'package:taskoria/data/models/quest.dart';
import 'package:taskoria/presentation/providers/quest_provider.dart';
import 'package:taskoria/presentation/providers/user_profile_provider.dart';

import '../../data/models/user_profile.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              backgroundColor: AppTheme.backgroundLight,
              appBar: AppBar(
                title: const Text('Profile'),
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.settings_outlined),
                  ),
                ],
              ),
              body: userProfileState.when(
                data: (profile) {
                  if (profile == null) {
                    return const Center(child: Text('No user profile found'));
                  }
                  return questListState.when(
                    data: (quests) {
                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            // Profile Header
                            _buildProfileHeader(profile),

                            const SizedBox(height: 24),

                            // Stats Cards
                            _buildStatsCards(profile, quests),

                            const SizedBox(height: 24),

                            // Achievements Section
                            _buildAchievementsSection(profile),

                            const SizedBox(height: 24),

                            // Settings Section
                            _buildSettingsSection(),
                          ],
                        ),
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, stack) =>
                        Center(child: Text('Error loading quests: $error')),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) =>
                    Center(child: Text('Error loading profile: $error')),
              ),
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

  Widget _buildProfileHeader(UserProfile profile) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primaryRed, AppTheme.darkRed],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person, color: Colors.white, size: 40),
            ),

            const SizedBox(height: 16),

            // Name and Title
            Text(
              profile.username,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            Text(
              '${profile.rank} • Level ${profile.level}',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
            ),

            const SizedBox(height: 16),

            // Edit Profile Button
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppTheme.primaryRed),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'Edit Profile',
                style: TextStyle(color: AppTheme.primaryRed),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCards(UserProfile profile, List<Quest> quests) {
    final completedQuests = quests
        .where((q) => q.status == QuestStatus.completed)
        .length;
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Quests\nCompleted',
            '$completedQuests',
            Icons.check_circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Current\nStreak',
            '${profile.weeklyProgress.currentStreakDays} days',
            Icons.local_fire_department,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Total\nXP',
            '${profile.currentXP}',
            Icons.star,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: AppTheme.primaryRed, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            Text(
              title,
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementsSection(UserProfile profile) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Achievements',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                TextButton(onPressed: () {}, child: Text('View All')),
              ],
            ),
            const SizedBox(height: 12),
            if (profile.achievements.isEmpty)
              Text(
                'No achievements yet. Keep completing quests to earn badges!',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
              )
            else
              Row(
                children: profile.achievements
                    .take(3)
                    .map(
                      (achievement) => Expanded(
                        child: Column(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: AppTheme.primaryRed,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.star,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              achievement,
                              style: TextStyle(
                                fontSize: 10,
                                color: AppTheme.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Card(
      child: Column(
        children: [
          _buildSettingItem(
            Icons.notifications_outlined,
            'Notifications',
            () {},
          ),
          _buildSettingItem(Icons.palette_outlined, 'Theme', () {}),
          _buildSettingItem(Icons.backup_outlined, 'Backup & Sync', () {}),
          _buildSettingItem(Icons.help_outline, 'Help & Support', () {}),
          _buildSettingItem(Icons.info_outline, 'About', () {}),
        ],
      ),
    );
  }

  Widget _buildSettingItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.textSecondary),
      title: Text(title),
      trailing: Icon(Icons.chevron_right, color: AppTheme.textSecondary),
      onTap: onTap,
    );
  }
}
