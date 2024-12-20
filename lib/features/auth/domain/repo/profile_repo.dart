import '../entities/profile_user.dart';

abstract class ProfileRepo{
Future<ProfileUser?> fetchUserProfile(String userId);
Future<void> updateProfile(ProfileUser updateProfile);

}