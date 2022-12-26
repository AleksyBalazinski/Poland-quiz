import 'dart:math';

import 'package:flutter/material.dart';
import 'package:poland_quiz/decoration.dart';
import 'package:poland_quiz/geojson.dart';
import 'package:poland_quiz/infojson.dart';
import 'package:poland_quiz/poland_map.dart';
import 'package:poland_quiz/quizes/feedback.dart';

class VoivodeshipOnMapQuiz extends StatefulWidget {
  final GeoJson data;
  final InfoJson info;
  final int initialHp;
  final int optionsCount;

  const VoivodeshipOnMapQuiz(
      {super.key,
      required this.data,
      required this.info,
      required this.initialHp,
      required this.optionsCount});

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
  late int _hp;

  void _setSelectedVoivodeship(String selected) {
    // no op
  }

  void _checkAnswer() {
    if (userAnswer == expectedAnswer) {
      setState(() => _pointsCount++);
      print("OK");
    } else {
      setState(() => _hp--);
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
      _hp = widget.initialHp;
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
    for (int i = 0; i < widget.optionsCount - 1; i++) {
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

    _hp = widget.initialHp;
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
