import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
  import 'package:instagram_clon/root/firebase_options.dart';

import 'root/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp( MyApp());
}


