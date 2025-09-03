import 'package:Taskoria/core/utilities/xp_utility.dart';

import '../core/event_manager.dart';
import '../repositories/base/profile_repository.dart';
import '../repositories/hive/hive_profile_repository.dart';
import '../models/profile.dart';
import '../types/event_type.dart';

class ProfileService {
  late final ProfileRepository dataSource;

  static ProfileService? _instance;

  ProfileService._() {
    dataSource = HiveProfileRepository();
  }

  static ProfileService get instance {
    _instance ??= ProfileService._();
    return _instance!;
  }

  Future<Profile?> getProfile() async {
    return await dataSource.getProfile();
  }

  Future<void> setProfile(Profile profile) async {
    // Calculate new level & rank
    final oldLevel = profile.level;
    final oldRank = profile.rank;

    profile.level = XpUtilities.calculateLevel(profile.currentXP);
    profile.rank = XpUtilities.calculateRank(profile.level);

    await dataSource.setProfile(profile);

    // Emit events if something changed
    if (profile.level > oldLevel) {
      EventManager().emit(LevelUp(profile.level));
    }
    if (profile.rank != oldRank) {
      EventManager().emit(
        RankChanged(XpUtilities.formatRankName(profile.rank)),
      );
    }

    EventManager().emit(ProfileEvent());
  }

  Future<void> updateXp(int xp) async {
    var profile = await getProfile();
    if (profile == null) throw Exception("Failed to retrieve profile");

    profile.currentXP += xp;

    if (xp > 0) {
      EventManager().emit(XpGained(xp));
    } else if (xp < 0) {
      EventManager().emit(XpLost(-xp));
    }

    await setProfile(profile);
  }
}
