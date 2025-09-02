import 'package:flutter/material.dart';
import 'package:Taskoria/core/theme/app_theme.dart';
import 'package:Taskoria/models/profile.dart';
import 'package:Taskoria/services/profile_service.dart';
import 'home_page.dart';
import '../widgets/rank_badge.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<StatefulWidget> createState() => OnboardingPageState();
}

class OnboardingPageState extends State<OnboardingPage> {
  final TextEditingController _usernameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Spacer(flex: 2),

                // Rank badges display (same as before)
                SizedBox(
                  height: 300, // Reduced height to make room for input
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Background gradient circle
                      Container(
                        width: 200,
                        height: 200,
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
                        top: 10,
                        child: RankBadge(
                          rank: 'TaskMaster',
                          color: AppTheme.primaryRed,
                          size: 80,
                          showGlow: true,
                        ),
                      ),

                      // Left badge
                      const Positioned(
                        left: 20,
                        top: 100,
                        child: RankBadge(
                          rank: 'Explorer',
                          color: AppTheme.sideQuestColor,
                          size: 60,
                        ),
                      ),

                      // Right badge
                      const Positioned(
                        right: 20,
                        top: 100,
                        child: RankBadge(
                          rank: 'Adventurer',
                          color: AppTheme.challengeColor,
                          size: 60,
                        ),
                      ),

                      // Bottom badges
                      const Positioned(
                        bottom: 20,
                        left: 60,
                        child: RankBadge(
                          rank: 'Newcomer',
                          color: Colors.grey,
                          size: 45,
                        ),
                      ),

                      const Positioned(
                        bottom: 30,
                        right: 40,
                        child: RankBadge(
                          rank: 'Seeker',
                          color: AppTheme.eventColor,
                          size: 40,
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

                const SizedBox(height: 32),

                // Username input
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Choose your adventurer name',
                    hintText: 'Enter your username',
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a username';
                    }
                    if (value.trim().length < 2) {
                      return 'Username must be at least 2 characters';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _handleStart(),
                ),

                const Spacer(flex: 2),

                // Get Started button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleStart,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(
                            'Start Your Adventure',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleStart() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final username = _usernameController.text.trim();
      final profile = Profile(
        username: username,
      ); // Assuming Profile has username parameter

      await ProfileService.instance.setProfile(profile);

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error creating profile: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
