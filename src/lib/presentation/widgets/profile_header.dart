import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:taskoria/core/services/level_service.dart';
import 'package:taskoria/core/theme/app_theme.dart';
import 'package:taskoria/data/models/user_profile.dart';

class ProfileHeader extends StatelessWidget {
  final UserProfile userProfile;

  const ProfileHeader({super.key, required this.userProfile});

  @override
  Widget build(BuildContext context) {
    final xpForNextLevel = LevelService.getXPForNextLevel(userProfile.level);
    final currentLevelXP = LevelService.getCurrentLevelXP(
      userProfile.currentXP,
      userProfile.level,
    );
    final progress = xpForNextLevel > 0 ? currentLevelXP / xpForNextLevel : 1.0;

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
            color: AppTheme.primaryRed.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top row with notifications
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.workspace_premium,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Pro Plan',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  _buildNotificationIcon(Icons.card_giftcard_outlined, true),
                  const SizedBox(width: 16),
                  _buildNotificationIcon(Icons.notifications_outlined, false),
                  const SizedBox(width: 16),
                  _buildNotificationIcon(Icons.search_outlined, false),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Profile section
          Row(
            children: [
              // Profile badge/avatar
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.3),
                      Colors.white.withOpacity(0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.4),
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
                          color: Colors.white.withOpacity(0.6),
                          width: 1,
                        ),
                      ),
                    ),
                    // Star icon
                    Icon(Icons.star, color: Colors.white, size: 24),
                  ],
                ),
              ),

              const SizedBox(width: 20),

              // User info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userProfile.rank,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Level ${userProfile.level}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${currentLevelXP}/${xpForNextLevel}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Progress bar
          LinearPercentIndicator(
            padding: EdgeInsets.zero,
            lineHeight: 8,
            percent: progress.clamp(0.0, 1.0),
            backgroundColor: Colors.white.withOpacity(0.3),
            progressColor: Colors.white,
            barRadius: const Radius.circular(4),
            animation: true,
            animationDuration: 1500,
          ),
        ],
      ),
    );
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
}
