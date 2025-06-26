import 'package:flutter/foundation.dart';

import '../models/extensions.dart';
import '../models/user_profile.dart';
// import '../models/enums.dart';
import 'hive_service.dart';
import 'xp_service.dart';

class UserService {
  static const String _defaultUserId = 'default_user';

  /// Get or create the default user profile
  static UserProfile getOrCreateProfile({String? name}) {
    final existingProfile = HiveService.userProfileBox.get(_defaultUserId);

    if (existingProfile != null) {
      return existingProfile;
    }

    // Create new profile
    final newProfile = UserProfile(
      id: _defaultUserId,
      name: name ?? 'Adventurer',
      createdAt: DateTime.now(),
      lastActiveAt: DateTime.now(),
    );

    HiveService.userProfileBox.put(_defaultUserId, newProfile);
    return newProfile;
  }

  /// Update user's XP and recalculate level/rank
  static Future<UserProfile> updateXP(int xpChange) async {
    final profile = getOrCreateProfile();

    // Update XP (ensure it doesn't go below 0)
    profile.totalXP = (profile.totalXP + xpChange)
        .clamp(0, double.infinity)
        .toInt();

    // Recalculate level and rank
    final newLevel = XPService.calculateLevelFromXP(profile.totalXP);
    final oldLevel = profile.currentLevel;

    profile.currentLevel = newLevel;
    profile.rank = UserRankExtension.fromLevel(newLevel);
    profile.lastActiveAt = DateTime.now();

    await profile.save();

    // Check for level up/down
    if (newLevel > oldLevel) {
      // Level up logic could be handled here
      if (kDebugMode) {
        print('Level up! New level: $newLevel');
      }
    } else if (newLevel < oldLevel) {
      // Level down logic could be handled here
      if (kDebugMode) {
        print('Level down! New level: $newLevel');
      }
    }

    return profile;
  }

  /// Update quest completion stats
  static Future<UserProfile> updateQuestStats({
    bool questCompleted = false,
    bool streakBroken = false,
  }) async {
    final profile = getOrCreateProfile();

    if (questCompleted) {
      profile.totalQuestsCompleted++;
    }

    if (streakBroken) {
      profile.totalStreaksBroken++;
    }

    profile.lastActiveAt = DateTime.now();
    await profile.save();

    return profile;
  }

  /// Get current user profile
  static UserProfile getCurrentProfile() {
    return getOrCreateProfile();
  }

  /// Update user name
  static Future<UserProfile> updateName(String newName) async {
    final profile = getOrCreateProfile();
    profile.name = newName;
    profile.lastActiveAt = DateTime.now();
    await profile.save();
    return profile;
  }

  /// Get user stats summary
  static Map<String, dynamic> getUserStats() {
    final profile = getCurrentProfile();

    return {
      'totalXP': profile.totalXP,
      'currentLevel': profile.currentLevel,
      'rank': profile.rank.displayName,
      'xpForNextLevel': XPService.calculateXPForNextLevel(profile.totalXP),
      'levelProgress': XPService.calculateLevelProgress(profile.totalXP),
      'totalQuestsCompleted': profile.totalQuestsCompleted,
      'totalStreaksBroken': profile.totalStreaksBroken,
      'daysSinceCreation': DateTime.now().difference(profile.createdAt).inDays,
    };
  }
}
