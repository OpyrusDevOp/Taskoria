import '../models/user_profile.dart';
import 'hive_service.dart';

class UserProfileService {
  static Future<UserProfile?> getProfile() async {
    final box = HiveService.userProfileBox;
    if (box.isEmpty) return null;
    return box.values.first;
  }

  static Future<void> saveProfile(UserProfile profile) async {
    final box = HiveService.userProfileBox;
    await box.put(profile.id, profile);
  }

  static Future<void> updateXP(int xp) async {
    final profile = await getProfile();
    if (profile == null) return;
    profile.totalXP += xp;
    await saveProfile(profile);
  }

  static Future<void> incrementQuestsCompleted() async {
    final profile = await getProfile();
    if (profile == null) return;
    profile.totalQuestsCompleted += 1;
    await saveProfile(profile);
  }

  static Future<void> incrementStreaksBroken() async {
    final profile = await getProfile();
    if (profile == null) return;
    profile.totalStreaksBroken += 1;
    await saveProfile(profile);
  }
}
