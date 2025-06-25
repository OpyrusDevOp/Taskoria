import 'package:hive/hive.dart';
import 'package:taskoria/data/models/user_profile.dart';

class UserProfileDataSource {
  static const String boxName = 'user_profile';
  Box<UserProfile>? _profileBox;
  bool _isInitialized = false;

  Future<void> init() async {
    if (!_isInitialized) {
      _profileBox = await Hive.openBox<UserProfile>(boxName);
      _isInitialized = true;
    }
  }

  Future<Box<UserProfile>> _getBox() async {
    if (!_isInitialized || _profileBox == null) {
      await init();
    }
    return _profileBox!;
  }

  Future<UserProfile?> getUserProfile() async {
    final box = await _getBox();
    return box.values.isNotEmpty ? box.values.first : null;
  }

  Future<void> saveUserProfile(UserProfile profile) async {
    final box = await _getBox();
    await box.clear(); // Since we only store one profile
    await box.add(profile);
  }

  Future<void> updateUserProfile(UserProfile profile) async {
    final box = await _getBox();
    await box.clear();
    await box.add(profile);
  }
}
