import 'package:Taskoria/core/utilities/xp_utility.dart';

import '../repositories/base/profile_repository.dart';
import '../repositories/hive/hive_profile_repository.dart';
import '../models/profile.dart';

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
    profile.level = XpUtilities.calculateLevel(profile.currentXP);
    profile.rank = XpUtilities.calculateRank(profile.level);

    await dataSource.setProfile(profile);
  }
}
