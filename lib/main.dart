import 'package:flutter/material.dart';
import 'package:poland_quiz/pages/opening_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:poland_quiz/routes.dart';
import 'firebase_options.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: AppRoutes.define(),
      title: 'Poland Quiz',
      home: const OpeningView(),
    );
  }
}
