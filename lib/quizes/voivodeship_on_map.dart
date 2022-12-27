import 'dart:math';

import 'package:flutter/material.dart';
import 'package:poland_quiz/geojson.dart';
import 'package:poland_quiz/infojson.dart';
import 'package:poland_quiz/poland_map.dart';
import 'package:poland_quiz/quizes/feedback.dart';
import 'package:poland_quiz/quizes/quiz_status.dart';

class VoivodeshipOnMapQuiz extends StatefulWidget {
  final GeoJson data;
  final InfoJson info;
  final int initialHp;
  final int optionsCount;
  final int level;

  const VoivodeshipOnMapQuiz(
      {super.key,
      required this.data,
      required this.info,
      required this.initialHp,
      required this.optionsCount,
      required this.level});

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
  late int questionsCount;
  final int questionsPerLevel = 3;
  late int level;

  void _setSelectedVoivodeship(String selected) {
    // no op
  }

  void _checkAnswer() {
    if (userAnswer == expectedAnswer) {
      setState(() => _pointsCount++);
    } else {
      setState(() => _hp--);
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

    return answerPool..shuffle();
  }

  @override
  void initState() {
    super.initState();

    _hp = widget.initialHp;
    level = widget.level;
    questionsCount = widget.level * questionsPerLevel;
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
          QuizStatus(pointsCount: _pointsCount, level: level, hp: _hp),
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
          if (_hp == 0) ...[
            GameOverInfo(onPressed: _restart),
          ] else if (_pointsCount == questionsCount) ...[
            NextLevelInfo(
                onPressed: () {
                  _advanceToNextQuestion();
                  setState(() {
                    _pointsCount = 0;
                    level++;
                    questionsCount = level * questionsPerLevel;
                  });
                },
                level: level + 1),
          ] else if (userAnswer == null) ...[
            const EmptyInfo(),
          ] else if (userAnswer?.toLowerCase() ==
              expectedAnswer.toLowerCase()) ...[
            CorrectAnswerInfo(onPressed: _advanceToNextQuestion),
          ] else ...[
            WrongAnswerInfo(onPressed: _advanceToNextQuestion),
          ]
        ],
      ),
    );
  }
}
