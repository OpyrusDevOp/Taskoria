import 'package:hive/hive.dart';
import 'package:taskoria/data/models/user_profile.dart';

class UserProfileDataSource {
  static const String boxName = 'user_profile';
  late Box<UserProfile> _profileBox;

  Future<void> init() async {
    _profileBox = await Hive.openBox<UserProfile>(boxName);
  }

  Future<UserProfile?> getUserProfile() async {
    return _profileBox.values.isNotEmpty ? _profileBox.values.first : null;
  }

  Future<void> saveUserProfile(UserProfile profile) async {
    await _profileBox.clear(); // Since we only store one profile
    await _profileBox.add(profile);
  }

  Future<void> updateUserProfile(UserProfile profile) async {
    await _profileBox.clear();
    await _profileBox.add(profile);
  }
}
