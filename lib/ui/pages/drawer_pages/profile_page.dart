import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clon/features/auth/domain/cubits/profile_cubit/profile_cubit.dart';
import 'package:instagram_clon/features/auth/domain/cubits/profile_cubit/profile_state.dart';
import 'package:instagram_clon/features/auth/domain/entities/app_user.dart';
import 'package:instagram_clon/ui/pages/drawer_pages/edit_profile_page.dart';
import 'package:instagram_clon/ui/widgets/bio_box.dart';
import 'package:instagram_clon/utility/app_padding.dart';
import 'package:instagram_clon/utility/screen_utils.dart';

import '../../../features/auth/domain/cubits/auth_cubit/auth_cubit.dart';

class ProfilePage extends StatefulWidget {
  final String userId;

  const ProfilePage({super.key, required this.userId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final authCubit = context.read<AuthCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  late AppUser? currentUser = authCubit.currentUser;

  @override
  void initState() {
    super.initState();
    profileCubit.fetchUserProfile(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(builder: (context, state) {
      if (state is ProfileLoaded) {
        final user = state.profileUser;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfilePage(user: user,),
                    ),
                  );
                },
                icon: const Icon(Icons.settings),
              ),
            ],
          ),
          body: Padding(
            padding: Dis.only(lr: 10.w),
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(user.email),
                  SizedBox(
                    height: 10.h,
                  ),
                  CircleAvatar(
                    radius: 40,
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    child: const Icon(
                      Icons.person,
                      size: 50,
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  const Text(
                    'Bio',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  BioBox(text: user.bio),
                  SizedBox(
                    height: 20.h,
                  ),
                  const Text(
                    'Posts',
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ),
            ),
          ),
        );
      } else if (state is ProfileLoading) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else {
        return const Center(
          child: Text('No profile found..'),
        );
      }
    });
  }
}
