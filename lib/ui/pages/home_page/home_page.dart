import 'package:flutter/material.dart';

import '../drawer_pages/drawer_screen.dart';
import 'upload_post_page.dart';

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
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UploadPostPage(),
                ),
              );
            },
            icon: const Icon(
              Icons.add,
            ),
          )
        ],
      ),
    );
  }
}
