import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clon/features/auth/data/firebase_auth.dart';
import 'package:instagram_clon/features/auth/data/firebase_profile_repo.dart';
import 'package:instagram_clon/features/auth/domain/cubits/post_cubit/post_cubit.dart';
import 'package:instagram_clon/features/auth/domain/cubits/profile_cubit/profile_cubit.dart';
import 'package:instagram_clon/features/post/data/firebase_post_repo.dart';
import 'package:instagram_clon/storage/data/firebase_storage_repo.dart';

import '../features/auth/domain/cubits/auth_cubit/auth_cubit.dart';
import '../features/auth/domain/cubits/auth_cubit/auth_state.dart';
import '../ui/pages/home_page/home_page.dart';
import '../ui/pages/register_pages/sign_in_or_up.dart';

class MyApp extends StatelessWidget {
  final firebaseAuthRepo = FirebaseAuthRepo();
  final firebaseProfileRepo = FirebaseProfileRepo();
  final firebaseStorageRepo = FirebaseStorageRepo();
  final firebasePostRepo = FirebasePostRepo();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) =>
              AuthCubit(authRepo: firebaseAuthRepo)..checkAuth(),
        ),
        BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(
            profileRepo: firebaseProfileRepo,
            storageRepo: firebaseStorageRepo,
          ),
        ),
        BlocProvider<PostCubit>(
          create: (context) => PostCubit(
            postRepo: firebasePostRepo,
            storageRepo: firebaseStorageRepo,
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
          ),
          useMaterial3: false,
        ),
        home: BlocConsumer<AuthCubit, AuthStates>(
          builder: (context, authState) {
            if (authState is Authenticated) {
              return const HomePage();
            }
            if (authState is UnAuthenticated) {
              return const SignInOrUp();
            } else {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
