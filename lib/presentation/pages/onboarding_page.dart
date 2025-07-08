import 'package:flutter/material.dart';
import 'package:taskoria/core/theme/app_theme.dart';
import 'package:taskoria/services/user_profile_service.dart';
import 'package:taskoria/models/user_profile.dart';
import 'package:taskoria/services/utilitary.dart';
import 'home_page.dart';
import '../widgets/rank_badge.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _checkProfile();
  }

  Future<void> _checkProfile() async {
    final profile = await UserProfileService.getProfile();
    if (profile != null) {
      // Profile exists, go to HomePage
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      });
    } else {
      setState(() => _loading = false);
    }
  }

  Future<void> _createProfileAndGo(String name) async {
    final profile = UserProfile(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      totalXP: 0,
      currentLevel: 0,
      currentRank: Utilitary.calculateRank(0),
      createdAt: DateTime.now(),
      totalQuestsCompleted: 0,
      totalStreaksBroken: 0,
    );
    await UserProfileService.saveProfile(profile);
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }

  void _showNameDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('What\'s your name?'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter your name'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                Navigator.of(context).pop();
                _createProfileAndGo(name);
              }
            },
            child: const Text('Start'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Rank badges display
              SizedBox(
                height: 350,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background gradient circle
                    Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [
                            AppTheme.lightRed.withOpacity(0.3),
                            AppTheme.lightRed.withOpacity(0.1),
                            Colors.transparent,
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),

                    // Main badge (center-top)
                    const Positioned(
                      top: 20,
                      child: RankBadge(
                        rank: 'TaskMaster',
                        color: AppTheme.primaryRed,
                        size: 90,
                        showGlow: true,
                      ),
                    ),

                    // Left badge
                    const Positioned(
                      left: 20,
                      top: 120,
                      child: RankBadge(
                        rank: 'Explorer',
                        color: AppTheme.sideQuestColor,
                        size: 70,
                      ),
                    ),

                    // Right badge
                    const Positioned(
                      right: 20,
                      top: 120,
                      child: RankBadge(
                        rank: 'Adventurer',
                        color: AppTheme.challengeColor,
                        size: 70,
                      ),
                    ),

                    // Bottom left badge
                    const Positioned(
                      bottom: 40,
                      left: 60,
                      child: RankBadge(
                        rank: 'Newcomer',
                        color: Colors.grey,
                        size: 55,
                      ),
                    ),

                    // Bottom right badge
                    const Positioned(
                      bottom: 60,
                      right: 40,
                      child: RankBadge(
                        rank: 'Seeker',
                        color: AppTheme.eventColor,
                        size: 50,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Title
              Text(
                'Level Up Your Productivity',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // Description
              Text(
                'Complete daily quests, earn badges, and keep your streak going. The more you achieve, the faster you level up!',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textSecondary,
                  height: 1.6,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(flex: 2),

              // Get Started button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _showNameDialog,
                  child: const Text(
                    'Get Started',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

