import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/auth/domain/cubits/auth_cubit/auth_cubit.dart';
import '../../widgets/drawer_tile.dart';
import 'profile_page.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const DrawerHeader(
              child: Icon(
                Icons.person,
                size: 100,
              ),
            ),
            DrawerTile(
              onTap: () {
                Navigator.pop(context);
              },
              text: 'Home',
              icon: Icons.home,
            ),
            DrawerTile(
              onTap: () {
                Navigator.pop(context);

                final userId = context.read<AuthCubit>().currentUser!.userId;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(
                      userId: userId,
                    ),
                  ),
                );
              },
              text: 'profile',
              icon: Icons.person,
            ),
            DrawerTile(
              onTap: () {},
              text: 'search',
              icon: Icons.search,
            ),
            DrawerTile(
              onTap: () {},
              text: 'settings',
              icon: Icons.settings,
            ),
            Spacer(),
            DrawerTile(
              onTap: () {
                authCubit.logOut();
              },
              text: 'logout',
              icon: Icons.logout,
            ),
          ],
        ),
      ),
    );
  }
}
