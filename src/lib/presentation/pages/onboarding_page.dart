import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskoria/core/theme/app_theme.dart';
import 'package:taskoria/presentation/pages/home_page.dart';
import 'package:taskoria/presentation/providers/user_profile_provider.dart';
import 'package:taskoria/presentation/widgets/rank_badge.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final _usernameController = TextEditingController();
  bool _isCreatingProfile = false;

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProfileDataSourceState = ref.watch(
      userProfileDataSourceFutureProvider,
    );
    return userProfileDataSourceState.when(
      data: (_) {
        final userProfileState = ref.watch(userProfileProvider);
        return userProfileState.when(
          data: (profile) {
            if (profile != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              });
              return const SizedBox.shrink(); // Temporary placeholder while navigating
            }
            return _buildOnboardingUI(context);
          },
          loading: () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
          error: (error, stack) => Scaffold(
            body: Center(child: Text('Error loading profile: $error')),
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) => Scaffold(
        body: Center(child: Text('Error initializing data source: $error')),
      ),
    );
  }

  Widget _buildOnboardingUI(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 40),

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

                const SizedBox(height: 20),

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

                const SizedBox(height: 32),

                // Username Input for Fresh Start
                if (_isCreatingProfile) ...[
                  Text(
                    'Choose Your Adventurer Name',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      hintText: 'Enter your name...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppTheme.primaryRed),
                      ),
                    ),
                    textInputAction: TextInputAction.done,
                    onSubmitted: (value) {
                      _createProfile();
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _createProfile,
                      child: const Text(
                        'Start Your Adventure',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  // Default Get Started Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isCreatingProfile = true;
                        });
                      },
                      child: const Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      // TODO: Implement login or profile recovery if needed
                    },
                    child: const Text(
                      'I Have an Account',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _createProfile() {
    final username = _usernameController.text.trim();
    if (username.isNotEmpty) {
      ref.read(userProfileProvider.notifier).createProfile(username);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a valid name'),
          backgroundColor: AppTheme.primaryRed,
        ),
      );
    }
  }
}
