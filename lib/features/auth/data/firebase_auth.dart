import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clon/features/auth/domain/repo/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../entities/app_user.dart';

class FirebaseAuthRepo implements AuthRepo {
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseFireStore = FirebaseFirestore.instance;

  @override
  Future<AppUser?> getCurrentUser() async {
    final firebaseUser = firebaseAuth.currentUser;

    if (firebaseUser == null) {
      return null;
    }
    return AppUser(
      email: firebaseUser.email!,
      name: '',
      userId: firebaseUser.uid,
    );
  }

  @override
  Future<void> logOut() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<AppUser?> loginWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential =
          await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      AppUser user = AppUser(
        email: email,
        name: '',
        userId: userCredential.user!.uid,
      );

      return user;
    } catch (e) {
      throw Exception('Login failed:$e');
    }
  }

  @override
  Future<AppUser?> registerWithEmailPassword(
    String email,
    String password,
    String name,
  ) async {
    try {
      UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      AppUser user = AppUser(
        email: email,
        name: name,
        userId: userCredential.user!.uid,
      );

      await firebaseFireStore
          .collection('users')
          .doc(user.userId)
          .set(user.toJson());

      return user;
    } catch (e) {
      throw Exception(
        'Register failed:$e',
      );
    }
  }
}
