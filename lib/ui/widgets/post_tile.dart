import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clon/features/entities/post.dart';
import 'package:instagram_clon/utility/app_padding.dart';
import 'package:instagram_clon/utility/screen_utils.dart';

class PostTile extends StatelessWidget {
  final Post post;
  final void Function()? onTap;

  const PostTile({
    super.key,
    required this.post,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Dis.only(
        lr: 10.w,
        tb: 8.h,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                post.userName,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                ),
              ),
              IconButton(
                onPressed: onTap,
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          CachedNetworkImage(
            imageUrl: post.imageUrl,
            height: 430.h,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => SizedBox(
              height: 430.h,
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ],
      ),
    );
  }
}
