import '../../models/profile.dart';

abstract class ProfileRepository {
  Future<Profile?> getProfile();
  Future<void> setProfile(Profile profile);
}
