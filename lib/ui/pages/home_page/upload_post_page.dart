import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clon/features/auth/domain/cubits/auth_cubit/auth_cubit.dart';
import 'package:instagram_clon/features/auth/domain/cubits/post_cubit/post_cubit.dart';
import 'package:instagram_clon/features/auth/domain/cubits/post_cubit/post_state.dart';
import 'package:instagram_clon/features/entities/app_user.dart';
import 'package:instagram_clon/features/entities/post.dart';
import 'package:instagram_clon/ui/widgets/textfields.dart';
import 'package:instagram_clon/utility/app_padding.dart';
import 'package:instagram_clon/utility/screen_utils.dart';

class UploadPostPage extends StatefulWidget {
  const UploadPostPage({super.key});

  @override
  State<UploadPostPage> createState() => _UploadPostPageState();
}

class _UploadPostPageState extends State<UploadPostPage> {
  PlatformFile? imagePickedFile;
  final textController = TextEditingController();
  AppUser? currentUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
  }

  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      setState(() {
        imagePickedFile = result.files.first;
      });
    }
  }

  void uploadPost() {
    if (imagePickedFile == null || textController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Fields are not filled',
          ),
        ),
      );
      return;
    }

    final newPost = Post(
      text: textController.text,
      userId: currentUser!.userId,
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      timStamp: DateTime.now(),
      imageUrl: '',
      userName: currentUser!.name,
      likes: [],
    );

    final postCubit = context.read<PostCubit>();
    postCubit.createPost(newPost, imagePickedFile!.path);
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostState>(
      builder: (context, state) {
        print(state);
        if (state is PostsLoading || state is PostsUploading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return buildUploadPage();
      },
      listener: (context, state) {
        if (state is PostsLoaded) {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget buildUploadPage() {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: uploadPost,
            icon: const Icon(Icons.check),
          ),
        ],
        title: const Text('Create post'),
      ),
      body: Padding(
        padding: Dis.only(lr: 10.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (imagePickedFile != null)
                Image.file(
                  File(
                    imagePickedFile!.path!,
                  ),
                ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: MaterialButton(
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: pickImage,
                  child: const Text(
                    'Pick image',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              TextFields(
                hintText: 'Captions',
                controller: textController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
