import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clon/features/auth/domain/cubits/profile_cubit/profile_cubit.dart';
import 'package:instagram_clon/features/auth/domain/cubits/profile_cubit/profile_state.dart';
import 'package:instagram_clon/features/auth/domain/entities/profile_user.dart';
import 'package:instagram_clon/ui/widgets/textfields.dart';
import 'package:instagram_clon/utility/app_padding.dart';
import 'package:instagram_clon/utility/screen_utils.dart';

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
  final bioController = TextEditingController();

  void updateProfile() async {
    final profileCubit = context.read<ProfileCubit>();
    if (bioController.text.isNotEmpty) {
      profileCubit.updateUserProfile(
        userId: widget.user.userId,
        newBio: bioController.text,
      );
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
        if(state is ProfileLoading){
          Navigator.pop(context);
        }
      },
    );
  }

  Widget buildEditPage({double uploadProgress = 0.0}) {
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
              SizedBox(
                height: 10.h,
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
