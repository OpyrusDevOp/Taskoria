import 'package:flutter/material.dart';
import 'package:taskoria/core/theme/app_theme.dart';
import 'package:taskoria/models/extensions.dart';
import 'package:taskoria/services/user_service.dart';
import 'package:taskoria/services/app_service.dart';
import 'home_page.dart';
import '../widgets/rank_badge.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  bool _isLoading = false;
  bool _hasExistingProfile = false;

  @override
  void initState() {
    super.initState();
    _checkExistingProfile();
  }

  void _checkExistingProfile() {
    // Check if user already has a profile
    try {
      final profile = UserService.getCurrentProfile();
      setState(() {
        _hasExistingProfile =
            profile.totalQuestsCompleted > 0 || profile.totalXP > 0;
      });
    } catch (e) {
      // No existing profile, that's fine
      setState(() {
        _hasExistingProfile = false;
      });
    }
  }

  Future<void> _startJourney() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Perform daily maintenance
      await AppService.performDailyMaintenance();

      // Get or create user profile
      UserService.getOrCreateProfile(
        name: 'Adventurer', // Default name, can be changed later
      );

      // Navigate to home page
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } catch (e) {
      // Handle error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error starting your journey: $e'),
            backgroundColor: AppTheme.primaryRed,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _continueJourney() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Perform daily maintenance
      await AppService.performDailyMaintenance();

      // Navigate to home page
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } catch (e) {
      // Handle error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error continuing your journey: $e'),
            backgroundColor: AppTheme.primaryRed,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                            AppTheme.lightRed.withValues(alpha: 0.3),
                            AppTheme.lightRed.withValues(alpha: 0.1),
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
                _hasExistingProfile
                    ? 'Welcome Back, Adventurer!'
                    : 'Level Up Your Productivity',
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
                _hasExistingProfile
                    ? 'Ready to continue your quest? Check your progress and tackle new challenges!'
                    : 'Complete daily quests, earn badges, and keep your streak going. The more you achieve, the faster you level up!',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textSecondary,
                  height: 1.6,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(flex: 2),

              // Main action button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : (_hasExistingProfile
                            ? _continueJourney
                            : _startJourney),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          _hasExistingProfile
                              ? 'Continue Journey'
                              : 'Start Journey',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),

              // Show profile info if exists
              if (_hasExistingProfile) ...[
                const SizedBox(height: 16),
                _buildProfilePreview(),
              ],

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePreview() {
    try {
      final profile = UserService.getCurrentProfile();
      final stats = UserService.getUserStats();

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.cardLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.lightRed, width: 1),
        ),
        child: Row(
          children: [
            // Rank badge
            RankBadge(
              rank: profile.rank.displayName,
              color: AppTheme.primaryRed,
              size: 40,
            ),

            const SizedBox(width: 12),

            // Profile info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Level ${profile.currentLevel} • ${profile.totalXP} XP',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  if (profile.totalQuestsCompleted > 0) ...[
                    const SizedBox(height: 4),
                    Text(
                      '${profile.totalQuestsCompleted} quests completed',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // XP progress indicator
            if (stats['levelProgress'] > 0) ...[
              const SizedBox(width: 12),
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  value: stats['levelProgress'],
                  backgroundColor: AppTheme.lightRed,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppTheme.primaryRed,
                  ),
                  strokeWidth: 3,
                ),
              ),
            ],
          ],
        ),
      );
    } catch (e) {
      return const SizedBox.shrink();
    }
  }
}
