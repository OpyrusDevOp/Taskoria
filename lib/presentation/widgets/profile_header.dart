import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:taskoria/core/theme/app_theme.dart';
import 'package:taskoria/services/user_profile_service.dart';
import 'package:taskoria/services/utilitary.dart';
import 'package:taskoria/models/user_profile.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({super.key});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  UserProfile? _profile;
  bool _isLoading = true;

  int _currentLevelXP = 0;
  int _nextLevelXP = 0;
  int _currentLevelProgress = 0;
  int _levelRange = 0;
  double _levelProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await UserProfileService.getProfile();
    if (profile != null) {
      final currentLevel = profile.currentLevel;
      final totalXP = profile.totalXP;

      // Calculate XP thresholds for current and next level
      int currentLevelXP = 0;
      for (int i = 0; i < currentLevel; i++) {
        currentLevelXP += Utilitary.xpForLevel(i);
      }
      int nextLevelXP = currentLevelXP + Utilitary.xpForLevel(currentLevel);

      int currentLevelProgress = totalXP - currentLevelXP;
      int levelRange = nextLevelXP - currentLevelXP;
      double levelProgress = levelRange > 0
          ? currentLevelProgress / levelRange
          : 1.0;

      setState(() {
        _profile = profile;
        _isLoading = false;
        _currentLevelXP = currentLevelXP;
        _nextLevelXP = nextLevelXP;
        _currentLevelProgress = currentLevelProgress;
        _levelRange = levelRange;
        _levelProgress = levelProgress.clamp(0.0, 1.0);
      });
    } else {
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

    if (_profile == null) {
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
        ),
        child: const Center(
          child: Text(
            "No profile found.",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      );
    }

    final profile = _profile!;
    final currentLevel = profile.currentLevel;
    final rank = Utilitary.formatRankName(profile.currentRank.name);
    final totalQuestsCompleted = profile.totalQuestsCompleted;
    final totalXP = profile.totalXP;

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
          // Profile section
          Row(
            children: [
              // Profile badge/avatar with level
              _buildProfileBadge(currentLevel, profile.currentRank.name),

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
                        : '$_currentLevelProgress/$_levelRange',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (currentLevel < 100) ...[
                    const SizedBox(height: 2),
                    Text(
                      '${_nextLevelXP - totalXP} to next',
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
              percent: _levelProgress,
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
}

