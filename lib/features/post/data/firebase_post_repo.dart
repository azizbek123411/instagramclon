import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clon/features/entities/post.dart';
import 'package:instagram_clon/features/post/data/repo.dart';

class FirebasePostRepo implements PostRepo {
  final fireStore = FirebaseFirestore.instance;
  final postCollection = FirebaseFirestore.instance.collection('posts');

  @override
  Future<void> createPost(Post post) async {
    try {
      await postCollection.doc(post.id).set(post.toJson());
    } catch (e) {
      throw Exception("Error:$e");
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    await postCollection.doc(postId).delete();
  }

  @override
  Future<List<Post>> fetchAllPosts() async {
    try {
      final postSnapshot =
          await postCollection.orderBy('timStamp', descending: true).get();

      final List<Post> allPosts = postSnapshot.docs
          .map(
            (doc) => Post.fromJson(
              doc.data() as Map<String, dynamic>,
            ),
          )
          .toList();

      return allPosts;
    } catch (e) {
      throw Exception("Error:$e");
    }
  }

  @override
  Future<List<Post>> fetchPostsByUserId(String? userId) async {
    try {
      final postSnapshot =
          await postCollection.where('userId', isEqualTo: userId).get();

      final userPosts = postSnapshot.docs
          .map(
            (doc) => Post.fromJson(
              doc.data() as Map<String, dynamic>,
            ),
          )
          .toList();

      return userPosts;
    } catch (e) {
      throw Exception('Error:$e');
    }
  }
}
