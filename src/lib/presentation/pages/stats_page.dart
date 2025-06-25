import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:taskoria/core/theme/app_theme.dart';
import 'package:taskoria/data/models/quest.dart';
import 'package:taskoria/presentation/providers/quest_provider.dart';
import 'package:taskoria/presentation/providers/user_profile_provider.dart';

import '../../data/models/user_profile.dart';

class StatsPage extends ConsumerWidget {
  const StatsPage({super.key});

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
                title: const Text('Statistics'),
                automaticallyImplyLeading: false,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Weekly Progress Card
                            _buildWeeklyProgressCard(quests),

                            const SizedBox(height: 20),

                            // Stats Grid
                            _buildStatsGrid(profile),

                            const SizedBox(height: 20),

                            // Quest Types Chart
                            _buildQuestTypesChart(quests),

                            const SizedBox(height: 20),

                            // Recent Achievements
                            _buildRecentAchievements(profile),
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

  Widget _buildWeeklyProgressCard(List<Quest> quests) {
    final completedThisWeek = quests
        .where(
          (q) =>
              q.completedAt != null &&
              q.completedAt!.isAfter(
                DateTime.now().subtract(const Duration(days: 7)),
              ),
        )
        .length;
    final totalThisWeek = quests
        .where(
          (q) =>
              q.createdAt.isAfter(
                DateTime.now().subtract(const Duration(days: 7)),
              ) ||
              (q.completedAt != null &&
                  q.completedAt!.isAfter(
                    DateTime.now().subtract(const Duration(days: 7)),
                  )),
        )
        .length;
    final percent = totalThisWeek > 0 ? completedThisWeek / totalThisWeek : 0.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This Week\'s Progress',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$completedThisWeek/$totalThisWeek Quests',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryRed,
                        ),
                      ),
                      Text(
                        'Completed',
                        style: TextStyle(color: AppTheme.textSecondary),
                      ),
                    ],
                  ),
                ),
                CircularPercentIndicator(
                  radius: 40,
                  lineWidth: 8,
                  percent: percent,
                  center: Text(
                    '${(percent * 100).toInt()}%',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryRed,
                    ),
                  ),
                  progressColor: AppTheme.primaryRed,
                  backgroundColor: Colors.grey[200]!,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(UserProfile profile) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.2,
      children: [
        _buildStatCard(
          'Total XP',
          '${profile.currentXP}',
          Icons.star,
          Colors.amber,
        ),
        _buildStatCard(
          'Current Streak',
          '${profile.weeklyProgress.currentStreakDays} days',
          Icons.local_fire_department,
          Colors.orange,
        ),
        _buildStatCard(
          'Quests Done',
          '${profile.totalQuestsCompleted}',
          Icons.check_circle,
          Colors.green,
        ),
        _buildStatCard(
          'Current Level',
          '${profile.level}',
          Icons.trending_up,
          AppTheme.primaryRed,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
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

  Widget _buildQuestTypesChart(List<Quest> quests) {
    final mainCompleted = quests
        .where(
          (q) => q.type == QuestType.main && q.status == QuestStatus.completed,
        )
        .length;
    final mainTotal = quests.where((q) => q.type == QuestType.main).length;
    final sideCompleted = quests
        .where(
          (q) => q.type == QuestType.side && q.status == QuestStatus.completed,
        )
        .length;
    final sideTotal = quests.where((q) => q.type == QuestType.side).length;
    final recurrentCompleted = quests
        .where(
          (q) =>
              q.type == QuestType.recurrent &&
              q.status == QuestStatus.completed,
        )
        .length;
    final recurrentTotal = quests
        .where((q) => q.type == QuestType.recurrent)
        .length;
    final challengeCompleted = quests
        .where(
          (q) =>
              q.type == QuestType.challenge &&
              q.status == QuestStatus.completed,
        )
        .length;
    final challengeTotal = quests
        .where((q) => q.type == QuestType.challenge)
        .length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quest Types Completed',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _buildQuestTypeBar(
              'Main Quests',
              mainCompleted,
              mainTotal,
              AppTheme.mainQuestColor,
            ),
            _buildQuestTypeBar(
              'Side Quests',
              sideCompleted,
              sideTotal,
              AppTheme.sideQuestColor,
            ),
            _buildQuestTypeBar(
              'Daily Quests',
              recurrentCompleted,
              recurrentTotal,
              AppTheme.recurrentColor,
            ),
            _buildQuestTypeBar(
              'Challenges',
              challengeCompleted,
              challengeTotal,
              AppTheme.challengeColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestTypeBar(
    String label,
    int completed,
    int total,
    Color color,
  ) {
    final progress = total > 0 ? completed / total : 0.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
              Text(
                '$completed/$total',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearPercentIndicator(
            padding: EdgeInsets.zero,
            lineHeight: 8,
            percent: progress,
            backgroundColor: Colors.grey[200],
            progressColor: color,
            barRadius: const Radius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentAchievements(UserProfile profile) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Achievements',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            if (profile.achievements.isEmpty)
              Text(
                'No achievements yet. Keep completing quests to earn badges!',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
              )
            else
              ...profile.achievements
                  .take(3)
                  .map(
                    (achievement) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryRed.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.star,
                              color: AppTheme.primaryRed,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  achievement,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                                Text(
                                  'Achievement unlocked!',
                                  style: TextStyle(
                                    color: AppTheme.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

