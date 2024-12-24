import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clon/features/auth/domain/cubits/post_cubit/post_cubit.dart';
import 'package:instagram_clon/features/auth/domain/cubits/post_cubit/post_state.dart';
import 'package:instagram_clon/ui/widgets/post_tile.dart';

import '../drawer_pages/drawer_screen.dart';
import 'upload_post_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final postCubit = context.read<PostCubit>();

  void fetchAllPosts() {
    postCubit.fetchAllPosts();
  }

  void deletePost(String postId) {
    postCubit.deletePost(postId);
    fetchAllPosts();
  }

  @override
  void initState() {
    super.initState();
    fetchAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerScreen(),
      appBar: AppBar(
        title: const Text('It worked'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UploadPostPage(),
                ),
              );
            },
            icon: const Icon(
              Icons.add,
            ),
          )
        ],
      ),
      body: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          if (state is PostsLoading && state is PostsUploading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is PostsLoaded) {
            final allPosts = state.posts;
            if (allPosts.isEmpty) {
              return const Center(
                child: Text('No posts yet..'),
              );
            }
            return ListView.builder(
                itemCount: allPosts.length,
                itemBuilder: (context, index) {
                  final post = allPosts[index];
                  return PostTile(post: post, onTap: (){
                    deletePost(post.id);
                  },);
                });
          } else if (state is PostsError) {
            return Center(
              child: Text(state.message),
            );
          }else{
            return const SizedBox();
          }
        },
      ),
    );
  }
}
