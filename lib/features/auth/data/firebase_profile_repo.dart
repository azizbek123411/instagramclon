import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clon/features/auth/domain/repo/profile_repo.dart';

import '../../entities/profile_user.dart';

class FirebaseProfileRepo implements ProfileRepo {
  final FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;

  @override
  Future<ProfileUser?> fetchUserProfile(String userId) async {
    try {
      final userDoc =
          await firebaseFireStore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        final userData = userDoc.data();
        if (userData != null) {
          final followers = List<String>.from(userData['followers'] ?? []);
          final following = List<String>.from(userData['following'] ?? []);

          return ProfileUser(
            bio: userData['bio'] ?? ' ',
            imagePathUrl: userData['imagePathUrl'].toString(),
            email: userData['email'],
            name: userData['name'],
            userId: userId,
            following: following,
            followers: followers,
          );
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> updateProfile(ProfileUser updateProfile) async {
    try {
      await firebaseFireStore
          .collection('users')
          .doc(updateProfile.userId)
          .update(
        {
          'bio': updateProfile.bio,
          'imagePathUrl': updateProfile.imagePathUrl,
        },
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> toggleFollow(String currentUserId, String targetUserId) async {
    try {
      final currentUserDoc =
          await firebaseFireStore.collection('users').doc(currentUserId).get();
      final targetUserDoc =
          await firebaseFireStore.collection('users').doc(targetUserId).get();

      if (currentUserDoc.exists && targetUserDoc.exists) {
        final currentUserData = currentUserDoc.data();
        final targetUserData = targetUserDoc.data();

        if (currentUserData != null && targetUserData != null) {
          final List<String> currentFollowing =
              List<String>.from(currentUserData['following'] ?? []);
          if (currentFollowing.contains(targetUserId)) {
            await firebaseFireStore
                .collection('users')
                .doc(currentUserId)
                .update({
              'following': FieldValue.arrayRemove(
                ([targetUserId]),
              ),
            });

            await firebaseFireStore
                .collection('users')
                .doc(currentUserId)
                .update({
              'followers': FieldValue.arrayRemove(
                ([currentUserId]),
              ),
            });
          } else {
            await firebaseFireStore
                .collection('users')
                .doc(currentUserId)
                .update({
              'following': FieldValue.arrayUnion(
                ([targetUserId]),
              )
            });
            await firebaseFireStore
                .collection('users')
                .doc(targetUserId)
                .update({
              'followers': FieldValue.arrayUnion(
                ([currentUserId]),
              ),
            });
          }
        }
      }
    } catch (e) {}
  }
}
