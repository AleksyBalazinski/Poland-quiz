import 'dart:math';

import 'package:flutter/material.dart';
import 'package:poland_quiz/geojson.dart';
import 'package:poland_quiz/infojson.dart';
import 'package:poland_quiz/decoration.dart';
import 'package:poland_quiz/poland_map.dart';
import 'package:poland_quiz/quizes/feedback.dart';

class PositionOfVoivodeship extends StatefulWidget {
  final GeoJson data;
  final InfoJson info;
  final int initalHp;

  const PositionOfVoivodeship(
      {super.key,
      required this.data,
      required this.info,
      required this.initalHp});

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

  GlobalKey<PolandMapState> _key = GlobalKey();

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
      print('OK');
    } else {
      setState(() => _hp--);
      if (_hp == 0) {
        print('game over!');
      }
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
          getFeedback(
            answerConfirmed,
            userAnswer?.toLowerCase() == expectedAnswer.toLowerCase(),
            _advanceToNextQuestion,
            _hp == 0,
            _restart,
          )
        ],
      ),
    );
  }
}
