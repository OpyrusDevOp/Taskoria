import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskoria/data/datasources/user_profile_datasource.dart';
import 'package:taskoria/data/models/user_profile.dart';
import 'package:taskoria/domain/repositories/user_profile_repository.dart';

final userProfileDataSourceProvider = Provider<UserProfileDataSource>((ref) {
  final dataSource = UserProfileDataSource();
  // We can't await init() here directly in a Provider, so we'll handle it in the repository or notifier
  return dataSource;
});

final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  return UserProfileRepository(ref.read(userProfileDataSourceProvider));
});

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, AsyncValue<UserProfile?>>((ref) {
      return UserProfileNotifier(ref.read(userProfileRepositoryProvider));
    });

class UserProfileNotifier extends StateNotifier<AsyncValue<UserProfile?>> {
  final UserProfileRepository _repository;

  UserProfileNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      state = const AsyncValue.loading();
      // Ensure the data source is initialized before accessing data
      await (await _repository.getUserProfile());
      final profile = await _repository.getUserProfile();
      state = AsyncValue.data(profile);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> createProfile(String username) async {
    try {
      state = const AsyncValue.loading();
      final newProfile = UserProfile(username: username);
      await _repository.saveUserProfile(newProfile);
      state = AsyncValue.data(newProfile);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateProfile(UserProfile profile) async {
    try {
      state = const AsyncValue.loading();
      await _repository.updateUserProfile(profile);
      state = AsyncValue.data(profile);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
