import 'package:Taskoria/models/profile.dart';
import 'package:Taskoria/repositories/base/profile_repository.dart';
import 'package:hive_flutter/adapters.dart';

class HiveProfileRepository extends ProfileRepository {
  static const String boxName = "profile";
  static const String profileKey = "default";

  Future<Box<Profile>> getBox() async => await Hive.openBox<Profile>(boxName);

  @override
  Future<Profile?> getProfile() async {
    var box = await getBox();

    return box.get(profileKey);
  }

  @override
  Future<void> setProfile(Profile profile) async {
    var box = await getBox();

    box.put(profileKey, profile);
  }
}
