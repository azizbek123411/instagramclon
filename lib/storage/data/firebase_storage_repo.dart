import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:instagram_clon/storage/domain/storage_repo.dart';

class FirebaseStorageRepo implements StorageRepo {
  final storage = FirebaseStorage.instance;

  @override
  Future<String?> uploadProfileImageMobile(String path, String fileName) {
    return _uploadFile(
      path,
      fileName,
      'profile_images',
    );
  }

  Future<String?> _uploadFile(
      String path, String fileName, String folder) async {
    try {
      final file = File(path);
      final storageRef = storage.ref().child('$folder/$fileName');
      final uploadTask = await storageRef.putFile(file);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<String?> uploadPostImagesMobile(String path, String fileName) {
   return _uploadFile(path, fileName, 'post_images');
  }
}
