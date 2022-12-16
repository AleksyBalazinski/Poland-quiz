import 'package:flutter/material.dart';
import 'package:poland_quiz/poland_map.dart';

class LearnPage extends StatelessWidget {
  const LearnPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learn page'),
      ),
      body: const Center(
        //child: Text('map of Poland goes here'),
        child: PolandMap(),
      ),
    );
  }
}
