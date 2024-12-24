import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clon/features/auth/domain/cubits/profile_cubit/profile_state.dart';
import 'package:instagram_clon/features/auth/domain/repo/profile_repo.dart';
import 'package:instagram_clon/features/entities/profile_user.dart';

import '../../../../../storage/domain/storage_repo.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;
  final StorageRepo storageRepo;

  ProfileCubit({
    required this.profileRepo,
    required this.storageRepo,
  }) : super(ProfileInitial());

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

  Future<ProfileUser?>getUserProfile(String userId)async{
  final user=await profileRepo.fetchUserProfile(userId);
  return user;
  }

  Future<void> updateUserProfile({
    String? newBio,
    required String userId,
    String? imageMobilePath,
  }) async {
    emit(ProfileLoading());
    try {
      final currentUser = await profileRepo.fetchUserProfile(userId);
      if (currentUser == null) {
        emit(
          ProfileError(
            message: "Failed to fetch user for profile update",
          ),
        );
        return;
      }

      String? imageDownloadUrl;
      if (imageMobilePath != null) {
        imageDownloadUrl = await storageRepo.uploadProfileImageMobile(
          imageMobilePath,
          userId,
        );
      }
      if (imageDownloadUrl == null) {
        emit(
          ProfileError(message: "Failed to upload image"),
        );
        return;
      }

      final updateProfile = currentUser.copyWith(
        newBio: newBio ?? currentUser.bio,
        newProfileImageUrl: imageDownloadUrl ?? currentUser.imagePathUrl,
      );

      await profileRepo.updateProfile(updateProfile);

      await fetchUserProfile(userId);
    } catch (e) {
      emit(ProfileError(message: "Error:$e"));
    }
  }
}
