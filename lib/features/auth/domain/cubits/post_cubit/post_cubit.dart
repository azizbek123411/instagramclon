import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clon/features/auth/domain/cubits/post_cubit/post_state.dart';
import 'package:instagram_clon/features/entities/post.dart';
import 'package:instagram_clon/features/post/data/repo.dart';
import 'package:instagram_clon/storage/domain/storage_repo.dart';

class PostCubit extends Cubit<PostState> {
  final PostRepo postRepo;
  final StorageRepo storageRepo;

  PostCubit({
    required this.postRepo,
    required this.storageRepo,
  }) : super(
          PostsInitial(),
        );

  Future<void> createPost(Post post, String? imagePath) async {
    String? imageUrl;

    try {
      if (imagePath != null) {
        emit(PostsUploading());
        imageUrl =
            await storageRepo.uploadPostImagesMobile(imagePath, post.id);
      }

      final newPost = post.copyWith(imageUrl: imageUrl);

      postRepo.createPost(newPost);

      fetchAllPosts();
    } catch (e) {
      emit(
        PostsError('Upload error:$e'),
      );
    }
  }

  Future<void> fetchAllPosts() async {
    try {
      emit(PostsLoading());
      final posts = await postRepo.fetchAllPosts();
      emit(PostsLoaded(posts));
    } catch (e) {
      emit(PostsError('fetching error:$e'));
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await postRepo.deletePost(postId);
    } catch (e) {}
  }
}
