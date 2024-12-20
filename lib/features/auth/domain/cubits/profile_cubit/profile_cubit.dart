import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clon/features/auth/domain/cubits/profile_cubit/profile_state.dart';
import 'package:instagram_clon/features/auth/domain/repo/profile_repo.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;

  ProfileCubit({required this.profileRepo}) : super(ProfileInitial());

  Future<void> fetchUserProfile(String userId) async {
    try {
      emit(ProfileLoading());
      final user = await profileRepo.fetchUserProfile(userId);

      if (user != null) {
        emit(ProfileLoaded(profileUser: user));
      } else {
        emit(ProfileError(message: 'User no found'));
      }
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> updateUserProfile(
      {String? newBio, required String userId}) async {
    emit(ProfileLoading());
    try {
      final currentUser = await profileRepo.fetchUserProfile(userId);
      if (currentUser == null) {
        emit(ProfileError(message: "Failed to fetch user for profile update"));
        return;
      }

      final updateProfile =
          currentUser.copyWith(newBio: newBio ?? currentUser.bio);

      await profileRepo.updateProfile(updateProfile);

      await fetchUserProfile(userId);
    } catch (e) {
      emit(ProfileError(message: "Error:$e"));
      }
  }
}
