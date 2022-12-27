import 'dart:math';

import 'package:flutter/material.dart';
import 'package:poland_quiz/geojson.dart';
import 'package:poland_quiz/infojson.dart';
import 'package:poland_quiz/poland_map.dart';
import 'package:poland_quiz/quizes/feedback.dart';
import 'package:poland_quiz/quizes/quiz_status.dart';

class PositionOfVoivodeship extends StatefulWidget {
  final GeoJson data;
  final InfoJson info;
  final int initalHp;
  final int level;

  const PositionOfVoivodeship(
      {super.key,
      required this.data,
      required this.info,
      required this.initalHp,
      required this.level});

  @override
  State<PositionOfVoivodeship> createState() => _PositionOfVoivodeshipState();
}

class _PositionOfVoivodeshipState extends State<PositionOfVoivodeship> {
  String? userAnswer;
  late List<String> voivodeships;
  late String expectedAnswer;
  final Random _random = Random();
  int _pointsCount = 0;
  late int _hp;
  bool answerConfirmed = false;
  late int questionsCount;
  final int questionsPerLevel = 3;
  late int level;

  final GlobalKey<PolandMapState> _key = GlobalKey();

  void _setSelectedVoivodeship(String selected) {
    setState(() {
      userAnswer = selected;
    });
  }

  void _checkAnswer() {
    setState(() {
      answerConfirmed = true;
    });
    if (userAnswer?.toLowerCase() == expectedAnswer.toLowerCase()) {
      setState(() => _pointsCount++);
    } else {
      setState(() => _hp--);
    }
  }

  void _advanceToNextQuestion() {
    setState(() {
      userAnswer = null;
      answerConfirmed = false;
      _key.currentState?.resetSelection();
    });
    expectedAnswer = _getNewExpectedAnswer();
  }

  void _restart() {
    setState(() {
      _pointsCount = 0;
      _hp = 3;
    });
    _advanceToNextQuestion();
  }

  String _getNewExpectedAnswer() {
    return voivodeships[_random.nextInt(voivodeships.length)];
  }

  @override
  void initState() {
    super.initState();

    _hp = widget.initalHp;
    voivodeships = widget.info.voivodeships.keys.toList();
    level = widget.level;
    questionsCount = widget.level * questionsPerLevel;
    _advanceToNextQuestion();
  }

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
      body: Column(
        children: [
          QuizStatus(pointsCount: _pointsCount, level: level, hp: _hp),
          Text('Where is $expectedAnswer voivodeship?'),
          PolandMap(
            key: _key,
            data: widget.data,
            onSelection: _setSelectedVoivodeship,
          ),
          ElevatedButton(
            onPressed:
                userAnswer == null || answerConfirmed ? null : _checkAnswer,
            child: const Text('Confirm'),
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
          ] else if (!answerConfirmed) ...[
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
