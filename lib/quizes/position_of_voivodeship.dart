import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:poland_quiz/geojson.dart';
import 'package:poland_quiz/infojson.dart';
import 'package:poland_quiz/poland_map.dart';
import 'package:poland_quiz/quizes/feedback.dart';
import 'package:poland_quiz/quizes/quiz_status.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PositionOfVoivodeship extends StatefulWidget {
  final GeoJson data;
  final InfoJson info;
  final int initalHp;
  final int level;
  final Function(int) nextLevelCallback;

  const PositionOfVoivodeship({
    super.key,
    required this.data,
    required this.info,
    required this.initalHp,
    required this.level,
    required this.nextLevelCallback,
  });

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
  late ConfettiController _confettiController;

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
      if (_pointsCount == questionsCount) {
        _confettiController.play();
      }
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
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    _advanceToNextQuestion();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.posOfVoivodeship),
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Column(
        children: [
          QuizStatus(pointsCount: _pointsCount, level: level, hp: _hp),
          Text(
            AppLocalizations.of(context)!.whereIsVoivodeship(expectedAnswer),
          ),
          PolandMap(
            key: _key,
            data: widget.data,
            onSelection: _setSelectedVoivodeship,
            intialSelection: answerConfirmed ? expectedAnswer : null,
            initialSelectionColor: answerConfirmed ? Colors.green : null,
          ),
          ElevatedButton(
            onPressed:
                userAnswer == null || answerConfirmed ? null : _checkAnswer,
            child: Text(AppLocalizations.of(context)!.confirm),
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
                  widget.nextLevelCallback(level);
                },
                level: level + 1),
          ] else if (!answerConfirmed) ...[
            const EmptyInfo(),
          ] else if (userAnswer?.toLowerCase() ==
              expectedAnswer.toLowerCase()) ...[
            CorrectAnswerInfo(onPressed: _advanceToNextQuestion),
          ] else ...[
            WrongAnswerInfo(onPressed: _advanceToNextQuestion),
          ],
          Align(
            alignment: Alignment.bottomCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: -pi / 2,
              maxBlastForce: 50,
              minBlastForce: 20,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              gravity: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
