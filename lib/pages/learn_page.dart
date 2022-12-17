import 'package:flutter/material.dart';
import 'package:poland_quiz/geojson.dart';
import 'package:poland_quiz/poland_map.dart';

class LearnPage extends StatelessWidget {
  const LearnPage({super.key});
  final String _mapPath = 'assets/gadm41_POL_1.json';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learn page'),
      ),
      body: FutureBuilder<GeoJson>(
        future: loadJson(_mapPath),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error has occurred!'),
            );
          } else if (snapshot.hasData) {
            return PolandMap(
              data: snapshot.data!,
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
