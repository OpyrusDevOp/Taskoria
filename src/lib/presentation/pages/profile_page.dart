import 'package:flutter/material.dart';
import 'package:taskoria/core/theme/app_theme.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Header
            _buildProfileHeader(),

            const SizedBox(height: 24),

            // Stats Cards
            _buildStatsCards(),

            const SizedBox(height: 24),

            // Achievements Section
            _buildAchievementsSection(),

            const SizedBox(height: 24),

            // Settings Section
            _buildSettingsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primaryRed, AppTheme.darkRed],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person, color: Colors.white, size: 40),
            ),

            const SizedBox(height: 16),

            // Name and Title
            Text(
              'Task Tactician',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            Text(
              'Level 3 • 1,250 XP',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
            ),

            const SizedBox(height: 16),

            // Edit Profile Button
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppTheme.primaryRed),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'Edit Profile',
                style: TextStyle(color: AppTheme.primaryRed),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard('Quests\nCompleted', '45', Icons.check_circle),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Current\nStreak',
            '7 days',
            Icons.local_fire_department,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard('Total\nXP', '1,250', Icons.star)),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: AppTheme.primaryRed, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
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

  Widget _buildAchievementsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Achievements',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                TextButton(onPressed: () {}, child: Text('View All')),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildAchievementBadge(Icons.star, 'First Quest'),
                const SizedBox(width: 12),
                _buildAchievementBadge(
                  Icons.local_fire_department,
                  'Week Warrior',
                ),
                const SizedBox(width: 12),
                _buildAchievementBadge(Icons.trending_up, 'Level Up'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementBadge(IconData icon, String title) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppTheme.primaryRed,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(fontSize: 10, color: AppTheme.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Card(
      child: Column(
        children: [
          _buildSettingItem(
            Icons.notifications_outlined,
            'Notifications',
            () {},
          ),
          _buildSettingItem(Icons.palette_outlined, 'Theme', () {}),
          _buildSettingItem(Icons.backup_outlined, 'Backup & Sync', () {}),
          _buildSettingItem(Icons.help_outline, 'Help & Support', () {}),
          _buildSettingItem(Icons.info_outline, 'About', () {}),
        ],
      ),
    );
  }

  Widget _buildSettingItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.textSecondary),
      title: Text(title),
      trailing: Icon(Icons.chevron_right, color: AppTheme.textSecondary),
      onTap: onTap,
    );
  }
}
