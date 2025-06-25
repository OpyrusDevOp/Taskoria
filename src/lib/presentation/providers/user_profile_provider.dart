import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskoria/data/datasources/user_profile_datasource.dart';
import 'package:taskoria/data/models/user_profile.dart';
import 'package:taskoria/domain/repositories/user_profile_repository.dart';

// FutureProvider to ensure data source initialization
final userProfileDataSourceFutureProvider =
    FutureProvider<UserProfileDataSource>((ref) async {
      final dataSource = UserProfileDataSource();
      await dataSource.init(); // Ensure initialization
      return dataSource;
    });

final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  // Use the initialized data source from FutureProvider
  final dataSource = ref.watch(userProfileDataSourceFutureProvider).value;
  if (dataSource == null) {
    throw Exception('UserProfileDataSource not initialized');
  }
  return UserProfileRepository(dataSource);
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
