import 'dart:math';

import 'package:flutter/material.dart';
import 'package:poland_quiz/decoration.dart';
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
  int _pointsCount = 0;
  int _hp = 3;

  void _setSelectedVoivodeship(String selected) {
    // no op
  }

  void _checkAnswer() {
    if (userAnswer == expectedAnswer) {
      _pointsCount++;
      print("OK");
    } else {
      _hp--;
      print("not OK");
      if (_hp == 0) {
        print('game over!');
      }
    }
  }

  void _advanceToNextQuestion() {
    setState(() => userAnswer = null);
    expectedAnswer = _getNewExpectedAnswer();
    answerPool = _getAnswerPool();
  }

  void _restart() {
    setState(() {
      _pointsCount = 0;
      _hp = 3;
    });
    _advanceToNextQuestion();
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
    _advanceToNextQuestion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voivodeship on the map'),
        centerTitle: true,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            decoration: getDecoration(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Points: $_pointsCount',
                  style: const TextStyle(fontSize: 20),
                ),
                Row(
                  children: [
                    for (int i = 0; i < _hp; i++)
                      const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      )
                  ],
                )
              ],
            ),
          ),
          PolandMap(
            data: widget.data,
            onSelection: _setSelectedVoivodeship,
            intialSelection: expectedAnswer,
          ),
          Wrap(
            spacing: 20,
            runSpacing: 10,
            children: [
              for (var ans in answerPool)
                ElevatedButton(
                  onPressed: userAnswer == null
                      ? () {
                          setState(() {
                            userAnswer = ans;
                          });
                          _checkAnswer();
                        }
                      : null,
                  child: Text(ans),
                )
            ],
          ),
          getFeedback(
            userAnswer != null,
            userAnswer == expectedAnswer,
            _advanceToNextQuestion,
            _hp == 0,
            _restart,
          ),
        ],
      ),
    );
  }
}

Widget getFeedback(bool anyAnswer, bool answeredCorrectly,
    Function() callbackContinue, bool gameOver, Function() callbackTryAgain) {
  if (gameOver) {
    return GameOverInfo(onPressed: callbackTryAgain);
  }

  if (!anyAnswer) {
    return const EmptyInfo();
  }

  if (answeredCorrectly) {
    return CorrectAnswerInfo(onPressed: callbackContinue);
  } else {
    return WrongAnswerInfo(onPressed: callbackContinue);
  }
}

class GameOverInfo extends StatelessWidget {
  const GameOverInfo({super.key, required this.onPressed});
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Game over!'),
        ElevatedButton(
          onPressed: onPressed,
          child: const Text('try again'),
        ),
      ],
    );
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
  const WrongAnswerInfo({super.key, required this.onPressed});
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: getDecoration(color: Colors.redAccent),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text(
            'Wrong answer',
            style: TextStyle(fontSize: 20),
          ),
          ElevatedButton(
            onPressed: onPressed,
            child: const Text('continue'),
          ),
        ],
      ),
    );
  }
}

class CorrectAnswerInfo extends StatelessWidget {
  const CorrectAnswerInfo({super.key, required this.onPressed});
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: getDecoration(color: Colors.green),
      child: Row(
        children: [
          const Text('Correct answer'),
          ElevatedButton(
            onPressed: onPressed,
            child: const Text('continue'),
          ),
        ],
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
