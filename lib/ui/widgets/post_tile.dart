import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clon/features/auth/domain/cubits/auth_cubit/auth_cubit.dart';
import 'package:instagram_clon/features/auth/domain/cubits/post_cubit/post_cubit.dart';
import 'package:instagram_clon/features/auth/domain/cubits/profile_cubit/profile_cubit.dart';
import 'package:instagram_clon/features/entities/app_user.dart';
import 'package:instagram_clon/features/entities/comment.dart';
import 'package:instagram_clon/features/entities/post.dart';
import 'package:instagram_clon/features/entities/profile_user.dart';
import 'package:instagram_clon/ui/widgets/textfields.dart';
import 'package:instagram_clon/utility/app_padding.dart';
import 'package:instagram_clon/utility/screen_utils.dart';

class PostTile extends StatefulWidget {
  final Post post;
  final void Function()? onTap;

  const PostTile({
    super.key,
    required this.post,
    required this.onTap,
  });

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  late final postCubit = context.read<PostCubit>();
  late final profileCubit = context.read<ProfileCubit>();
  final commentController = TextEditingController();

  bool isOwnPost = false;

  AppUser? currentUser;

  ProfileUser? postUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    fetchUserPosts();
  }

  void getCurrentUser() {
    final currentUser = context.read<AuthCubit>().currentUser;
    isOwnPost = (widget.post.userId == currentUser!.userId);
  }

  Future<void> fetchUserPosts() async {
    final fetchedUser = await profileCubit.getUserProfile(widget.post.userId);
    if (fetchedUser != null) {
      setState(() {
        postUser = fetchedUser;
      });
    }
  }

  void showOptions() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Delete Post?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  widget.onTap!();
                },
                child: const Text(
                  'Delete',
                ),
              ),
            ],
          );
        });
  }

  void toggleLikePost() {
    final isLiked = widget.post.likes.contains(currentUser!.userId);

    setState(() {
      if (isLiked) {
        widget.post.likes.remove(currentUser!.userId);
      } else {
        widget.post.likes.add(currentUser!.userId);
      }
    });

    postCubit
        .toggleLikePost(
      widget.post.id,
      currentUser!.userId,
    )
        .catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
        ),
      );
      setState(() {
        if (isLiked) {
          widget.post.likes.remove(currentUser!.userId);
        } else {
          widget.post.likes.add(currentUser!.userId);
        }
      });
    });
  }

  void openNewCommentBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextFields(
          hintText: 'Type comment',
          controller: commentController,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "Cancel",
            ),
          ),
          TextButton(
            onPressed: () {
              addComment();
              Navigator.pop(context);
            },
            child: const Text(
              "Save",
            ),
          ),
        ],
      ),
    );
  }

  void addComment() {
    final newComment = Comment(
      userId: widget.post.userId,
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      postId: widget.post.id,
      text: commentController.text,
      userName: widget.post.userName,
      timeStamp: DateTime.now(),
    );
    if (commentController.text.isNotEmpty) {
      postCubit.addComment(widget.post.id, newComment);
    }
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postTime = widget.post.timStamp;
    return Container(
      padding: Dis.only(
        lr: 10.w,
        tb: 8.h,
      ),
      child: Column(
        children: [
          Row(
            children: [
              postUser!.imagePathUrl != null
                  ? CachedNetworkImage(
                      imageBuilder: (context, imageProvider) => Container(
                        height: 30.h,
                        width: 30.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      imageUrl: postUser!.imagePathUrl,
                      errorWidget: (context, url, error) => const Icon(
                        Icons.person,
                      ),
                    )
                  : const Icon(
                      Icons.person,
                    ),
              SizedBox(
                width: 10.w,
              ),
              Text(
                widget.post.userName,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "    ${postTime.hour}:${postTime.minute}  ${postTime.day}/${postTime.month}/${postTime.year}",
              ),
              const Spacer(),
              if (isOwnPost)
                IconButton(
                  onPressed: showOptions,
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
            ],
          ),
          SizedBox(
            height: 8.h,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: widget.post.imageUrl,
              height: 430.h,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => SizedBox(
                height: 430.h,
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          Row(
            children: [
              // GestureDetector(
              //     onTap: toggleLikePost,
              //     child: Icon(
              //         widget.post.likes.contains(currentUser?.userId)
              //             ? Icons.favorite
              //             : Icons.favorite_outline,
              //         color: Colors.red)),
              // Text(widget.post.likes.length.toString()),
              IconButton(
                onPressed: () {
                  openNewCommentBox();
                },
                icon: const Icon(
                  Icons.insert_comment_outlined,
                  color: Colors.grey,
                ),
              ),
              Text(
                widget.post.comments.length.toString(),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                widget.post.userName,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "  ${widget.post.text}",
                style: const TextStyle(
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          Text(
            widget.post.text,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 30,
            ),
          ),
        ],
      ),
    );
  }
}
