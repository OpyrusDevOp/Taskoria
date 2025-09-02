import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'home_page.dart';
import '../widgets/rank_badge.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

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
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  },
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
