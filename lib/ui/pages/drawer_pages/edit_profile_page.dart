import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clon/features/auth/domain/cubits/profile_cubit/profile_cubit.dart';
import 'package:instagram_clon/features/auth/domain/cubits/profile_cubit/profile_state.dart';
import 'package:instagram_clon/ui/widgets/textfields.dart';
import 'package:instagram_clon/utility/app_padding.dart';
import 'package:instagram_clon/utility/screen_utils.dart';
import 'package:file_picker/file_picker.dart';

import '../../../features/entities/profile_user.dart';

class EditProfilePage extends StatefulWidget {
  final ProfileUser user;

  const EditProfilePage({
    super.key,
    required this.user,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  PlatformFile? imagePickedFile;

  final bioController = TextEditingController();

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

  void updateProfile() async {
    final profileCubit = context.read<ProfileCubit>();

    final String userId = widget.user.userId;
    final imageMobilePath = imagePickedFile!.path??'"https://firebasestorage.googleapis.com/v0/b/instagramclon-8fdc1.firebasestorage.app/o/profile_images%2FydcvVJ8Gy4U6PdbJswhj1THdG8A2?alt=media&token=3dc31480-b40e-43f8-b355-ab6985c24ba6';
    final String? newBio =
        bioController.text.isNotEmpty ? bioController.text : null;

    if (imagePickedFile != null ||newBio != null) {
      profileCubit.updateUserProfile(
        userId: userId,
        newBio: newBio,
        imageMobilePath: imageMobilePath,
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Text('Uploading...'),
              ],
            ),
          );
        } else {
          return buildEditPage();
        }
      },
      listener: (context, state) {
        if (state is ProfileLoading) {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget buildEditPage() {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: updateProfile,
            icon: const Icon(
              Icons.check,
            ),
          )
        ],
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: Dis.only(lr: 10.w),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Profile picture',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 10.h,
              ),
              Container(
                clipBehavior: Clip.hardEdge,
                height: 200.h,
                width: 200.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                child: imagePickedFile != null
                    ? Image.file(
                        File(
                          imagePickedFile!.path!,
                        ),
                        fit: BoxFit.cover,
                      )
                    : CachedNetworkImage(
                        imageUrl: widget.user.imagePathUrl,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.person,
                          size: 70,
                        ),
                        imageBuilder: (context, imageProvider) => Image(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: MaterialButton(
                  onPressed: pickImage,
                  color: Theme.of(context).colorScheme.primary,
                  child: const Text(
                    'Pick image',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              const Text(
                'Bio',
                style: TextStyle(fontSize: 20),
              ),
              TextFields(
                hintText: widget.user.bio ?? 'Empty bio..',
                controller: bioController,
              )
            ],
          ),
        ),
      ),
    );
  }
}
