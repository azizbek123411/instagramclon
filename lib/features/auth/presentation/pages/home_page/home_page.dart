import 'package:flutter/material.dart';
import 'package:instagram_clon/features/auth/presentation/pages/drawer_pages/drawer_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerScreen(),
      appBar: AppBar(
        title: const Text('It worked'),

      ),
    );
  }
}
