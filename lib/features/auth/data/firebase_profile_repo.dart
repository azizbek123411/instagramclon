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
          return ProfileUser(
            bio: userData['bio']??' ',
            imagePathUrl: userData['imagePathUrl'].toString(),
            email: userData['email'],
            name: userData['name'],
            userId: userId,
          );
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> updateProfile(ProfileUser updateProfile) async{

    try{
      await firebaseFireStore.collection('users').doc(updateProfile.userId).update(
          {
            'bio':updateProfile.bio,
            'imagePathUrl':updateProfile.imagePathUrl,
          },);

    }catch(e){
      throw Exception(e);
    }

  }
}
