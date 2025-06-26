import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:taskoria/core/theme/app_theme.dart';
import 'package:taskoria/services/user_service.dart';
import 'package:taskoria/services/xp_service.dart';
import 'package:taskoria/services/streak_service.dart';
import 'package:taskoria/services/daily_quest_service.dart';
// import 'package:taskoria/models/enums.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({super.key});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  Map<String, dynamic> _userStats = {};
  Map<String, dynamic> _streakStats = {};
  List<dynamic> _todayQuests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    try {
      final userStats = UserService.getUserStats();
      final streakStats = StreakService.getStreakStats();
      final todayQuests = DailyQuestService.getDailyQuestsDueToday();

      setState(() {
        _userStats = userStats;
        _streakStats = streakStats;
        _todayQuests = todayQuests;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingHeader();
    }

    final currentXP = _userStats['totalXP'] as int? ?? 0;
    final currentLevel = _userStats['currentLevel'] as int? ?? 0;
    final rank = _userStats['rank'] as String? ?? 'Newcomer';
    final xpForNextLevel = _userStats['xpForNextLevel'] as int? ?? 0;
    final levelProgress = _userStats['levelProgress'] as double? ?? 0.0;
    final totalQuestsCompleted =
        _userStats['totalQuestsCompleted'] as int? ?? 0;

    // Calculate current level XP range
    final currentLevelXP = currentLevel > 0
        ? XPService.calculateRequiredXP(currentLevel)
        : 0;
    final nextLevelXP = XPService.calculateRequiredXP(currentLevel + 1);
    final currentLevelProgress = currentXP - currentLevelXP;
    final levelRange = nextLevelXP - currentLevelXP;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryRed, AppTheme.darkRed],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryRed.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top row with stats and notifications
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Quick stats
              _buildQuickStats(),

              // Notification icons
              Row(
                children: [
                  _buildNotificationIcon(
                    Icons.notifications_outlined,
                    _hasNotifications(),
                  ),
                  const SizedBox(width: 16),
                  _buildNotificationIcon(
                    Icons.local_fire_department_outlined,
                    _streakStats['currentActiveStreaks'] > 0,
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Profile section
          Row(
            children: [
              // Profile badge/avatar with level
              _buildProfileBadge(currentLevel, rank),

              const SizedBox(width: 20),

              // User info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rank,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Level $currentLevel',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (totalQuestsCompleted > 0) ...[
                      const SizedBox(height: 2),
                      Text(
                        '$totalQuestsCompleted quests completed',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // XP Display
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'XP',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    currentLevel >= 100
                        ? 'MAX'
                        : '$currentLevelProgress/$levelRange',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (xpForNextLevel > 0) ...[
                    const SizedBox(height: 2),
                    Text(
                      '$xpForNextLevel to next',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Progress bar
          if (currentLevel < 100) ...[
            LinearPercentIndicator(
              padding: EdgeInsets.zero,
              lineHeight: 8,
              percent: levelProgress.clamp(0.0, 1.0),
              backgroundColor: Colors.white.withValues(alpha: 0.3),
              progressColor: Colors.white,
              barRadius: const Radius.circular(4),
              animation: true,
              animationDuration: 1500,
            ),
          ] else ...[
            // Max level indicator
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Center(
                child: Text(
                  'MAX LEVEL',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoadingHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      height: 180,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryRed, AppTheme.darkRed],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }

  Widget _buildQuickStats() {
    final activeStreaks = _streakStats['currentActiveStreaks'] as int? ?? 0;
    final longestStreak = _streakStats['longestCurrentStreak'] as int? ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (activeStreaks > 0) ...[
          Row(
            children: [
              const Icon(
                Icons.local_fire_department,
                color: Colors.orange,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                '$activeStreaks active',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          if (longestStreak > 0) ...[
            const SizedBox(height: 2),
            Text(
              'Best: $longestStreak days',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ],
        if (_todayQuests.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            '${_todayQuests.length} due today',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildProfileBadge(int level, String rank) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.3),
            Colors.white.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.4),
          width: 2,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer ring
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.6),
                width: 1,
              ),
            ),
          ),
          // Rank icon based on level
          Icon(_getRankIcon(level), color: Colors.white, size: 24),
          // Level indicator
          if (level > 0)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1),
                ),
                child: Center(
                  child: Text(
                    level > 99 ? '★' : '$level',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  IconData _getRankIcon(int level) {
    if (level == 0) return Icons.person_outline;
    if (level <= 15) return Icons.hiking_outlined;
    if (level <= 30) return Icons.explore_outlined;
    if (level <= 45) return Icons.search_outlined;
    if (level <= 60) return Icons.trending_up_outlined;
    if (level <= 70) return Icons.navigation_outlined;
    if (level <= 75) return Icons.task_outlined;
    if (level <= 80) return Icons.shield_outlined;
    if (level <= 85) return Icons.military_tech_outlined;
    if (level <= 90) return Icons.psychology_outlined;
    if (level <= 95) return Icons.emoji_events_outlined;
    if (level <= 99) return Icons.diamond_outlined;
    return Icons.star; // TaskMaster
  }

  Widget _buildNotificationIcon(IconData icon, bool hasNotification) {
    return Stack(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        if (hasNotification)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1),
              ),
            ),
          ),
      ],
    );
  }

  bool _hasNotifications() {
    // Check for overdue quests, streak risks, etc.
    final streaksAtRisk = _streakStats['currentActiveStreaks'] as int? ?? 0;
    return streaksAtRisk > 0 || _todayQuests.isNotEmpty;
  }
}

