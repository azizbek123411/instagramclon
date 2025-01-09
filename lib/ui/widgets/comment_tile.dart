import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clon/features/auth/domain/cubits/auth_cubit/auth_cubit.dart';
import 'package:instagram_clon/features/auth/domain/cubits/post_cubit/post_cubit.dart';
import 'package:instagram_clon/features/entities/app_user.dart';
import 'package:instagram_clon/features/entities/comment.dart';

class CommentTile extends StatefulWidget {
  final Comment comment;

  const CommentTile({
    super.key,
    required this.comment,
  });

  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  AppUser? currentUser;
  bool isOwnPost = false;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void showOptions() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Delete Comment?"),
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
                  context.read<PostCubit>().deleteComment(
                        widget.comment.postId,
                        widget.comment.id,
                      );
                },
                child: const Text(
                  'Delete',
                ),
              ),
            ],
          );
        });
  }

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
    isOwnPost = (widget.comment.userId == currentUser!.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          widget.comment.userName,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text("  ${widget.comment.text}"),
        const Spacer(),
        if (isOwnPost)
          GestureDetector(
            onTap: showOptions,
            child: const Icon(
              Icons.more_horiz,
              color: Colors.black54,
            ),
          )
      ],
    );
    ;
  }
}
