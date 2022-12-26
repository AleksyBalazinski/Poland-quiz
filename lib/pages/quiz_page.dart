import 'package:flutter/material.dart';
import 'package:poland_quiz/geojson.dart';
import 'package:poland_quiz/infojson.dart';
import 'package:poland_quiz/quizes/voivodeship_on_map.dart';
import 'package:poland_quiz/quizes/position_of_voivodeship.dart';

class QuizPage extends StatelessWidget {
  final GeoJson geoJson;
  final InfoJson infoJson;
  const QuizPage({super.key, required this.geoJson, required this.infoJson});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz selection page'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Voivodeship on the map'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => VoivodeshipOnMapQuiz(
                    data: geoJson,
                    info: infoJson,
                    initialHp: 3,
                    optionsCount: 4,
                  ),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Position of the voivodeship'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PositionOfVoivodeship(
                    data: geoJson,
                    info: infoJson,
                    initalHp: 3,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
