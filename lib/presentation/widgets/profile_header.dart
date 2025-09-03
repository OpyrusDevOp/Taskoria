import 'package:Taskoria/core/utilities/xp_utility.dart';
import 'package:Taskoria/presentation/event_observer.dart';
import 'package:Taskoria/services/profile_service.dart';
import 'package:Taskoria/types/event_type.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../core/theme/app_theme.dart';
import '../../models/profile.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({super.key});

  @override
  State<StatefulWidget> createState() => ProfileHeaderState();
}

class ProfileHeaderState extends State<ProfileHeader> with EventObserver {
  Profile? profile;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getProfile();

    listenTo<ProfileEvent>((_) => getProfile());
  }

  void getProfile() async {
    setState(() {
      isLoading = true;
    });

    var result = await ProfileService.instance.getProfile();

    if (result == null) throw Exception("No Profile found");

    setState(() {
      isLoading = false;
      profile = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (profile == null) {
      return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade400, Colors.grey.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Center(
          child: Text(
            'Profile not found',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      );
    }
    // Mock data for design
    var currentXP = profile!.currentXP;
    var level = profile!.level;
    var maxXP = XpUtilities.calculateRequiredXp(level + 1);
    var rank = XpUtilities.formatRankName(profile!.rank);
    var progress = XpUtilities.calculateProgress(currentXP, maxXP, level);
    var rankIcon = XpUtilities.getRankIcon(profile!.rank);

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
          // Top row with pro plan and notifications
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                    // Star icon
                    Icon(rankIcon, color: Colors.white, size: 24),
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
                      rank,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Level $level',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
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
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$currentXP/$maxXP',
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
            backgroundColor: Colors.white.withValues(alpha: 0.3),
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
