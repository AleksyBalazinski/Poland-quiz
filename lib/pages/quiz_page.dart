import 'dart:math';

import 'package:flutter/material.dart';
import 'package:poland_quiz/geojson.dart';
import 'package:poland_quiz/infojson.dart';
import 'package:poland_quiz/poland_map.dart';

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
                  builder: (context) => const PositionOfVoivodeship(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class VoivodeshipOnMapQuiz extends StatefulWidget {
  final GeoJson data;
  final InfoJson info;
  const VoivodeshipOnMapQuiz(
      {super.key, required this.data, required this.info});

  @override
  State<VoivodeshipOnMapQuiz> createState() => _VoivodeshipOnMapQuizState();
}

class _VoivodeshipOnMapQuizState extends State<VoivodeshipOnMapQuiz> {
  String? userAnswer;
  late List<String> voivodeships;
  late List<String> answerPool;
  late String expectedAnswer;
  final Random _random = Random();
  bool isAnswerCorrect = false;

  void _setSelectedVoivodeship(String selected) {
    // no op
  }

  void _checkAnswer() {
    if (userAnswer == expectedAnswer) {
      print("OK");
      isAnswerCorrect = true;
      expectedAnswer = _getNewExpectedAnswer();
      answerPool = _getAnswerPool();
    } else {
      print("not OK");
      isAnswerCorrect = false;
    }
  }

  String _getNewExpectedAnswer() {
    expectedAnswer = voivodeships[_random.nextInt(voivodeships.length)];
    print("Expected answer is $expectedAnswer");
    return expectedAnswer;
  }

  List<String> _getAnswerPool() {
    var wrongAnswers = [...voivodeships];
    wrongAnswers.removeWhere((element) => element == expectedAnswer);
    List<String> answerPool = [];
    for (int i = 0; i < 3; i++) {
      var option = wrongAnswers[_random.nextInt(wrongAnswers.length)];
      answerPool.add(option);
      wrongAnswers.removeWhere((element) => element == option);
    }
    answerPool.add(expectedAnswer);

    return answerPool;
  }

  @override
  void initState() {
    super.initState();

    voivodeships = widget.info.voivodeships.keys.toList();
    expectedAnswer = _getNewExpectedAnswer();
    answerPool = _getAnswerPool();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voivodeship on the map'),
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Column(
        children: [
          PolandMap(
            data: widget.data,
            onSelection: _setSelectedVoivodeship,
            intialSelection: expectedAnswer,
          ),
          Row(
            children: [
              for (var ans in answerPool)
                ElevatedButton(
                  onPressed: () {
                    setState(() => userAnswer = ans);
                    _checkAnswer();
                  },
                  child: Text(ans),
                )
            ],
          ),
          getFeedback(userAnswer != null, isAnswerCorrect)
        ],
      ),
    );
  }
}

Widget getFeedback(bool anyAnswer, bool answeredCorrectly) {
  if (!anyAnswer) {
    return const EmptyInfo();
  }

  if (answeredCorrectly) {
    return const CorrectAnswerInfo();
  } else {
    return const WrongAnswerInfo();
  }
}

class EmptyInfo extends StatelessWidget {
  const EmptyInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class WrongAnswerInfo extends StatelessWidget {
  const WrongAnswerInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Center(
        child: Text('Wrong answer'),
      ),
    );
  }
}

class CorrectAnswerInfo extends StatelessWidget {
  const CorrectAnswerInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Center(
        child: Text('Correct answer'),
      ),
    );
  }
}

class PositionOfVoivodeship extends StatelessWidget {
  const PositionOfVoivodeship({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Position of the voivodeship'),
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: const Center(
        child: Text('Position of the voivodeship quiz goes here'),
      ),
    );
  }
}
