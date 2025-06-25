import 'package:taskoria/data/datasources/user_profile_datasource.dart';
import 'package:taskoria/data/models/user_profile.dart';

class UserProfileRepository {
  final UserProfileDataSource _dataSource;

  UserProfileRepository(this._dataSource);

  Future<UserProfile?> getUserProfile() async {
    return await _dataSource.getUserProfile();
  }

  Future<void> saveUserProfile(UserProfile profile) async {
    await _dataSource.saveUserProfile(profile);
  }

  Future<void> updateUserProfile(UserProfile profile) async {
    await _dataSource.updateUserProfile(profile);
  }
}
