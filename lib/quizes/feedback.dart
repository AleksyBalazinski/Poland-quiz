import 'package:flutter/material.dart';
import 'package:poland_quiz/decoration.dart';

class GameOverInfo extends StatelessWidget {
  const GameOverInfo({super.key, required this.onPressed});
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(20),
        decoration: getDecoration(color: Colors.redAccent),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              'Game over!',
              style: TextStyle(fontSize: 20),
            ),
            ElevatedButton(
              onPressed: onPressed,
              child: const Text('try again'),
            ),
          ],
        ),
      ),
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
    return Expanded(
      child: Container(
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
      ),
    );
  }
}

class CorrectAnswerInfo extends StatelessWidget {
  const CorrectAnswerInfo({super.key, required this.onPressed});
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(20),
        decoration: getDecoration(color: Colors.green),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text('Correct answer'),
            ElevatedButton(
              onPressed: onPressed,
              child: const Text('continue'),
            ),
          ],
        ),
      ),
    );
  }
}

class NextLevelInfo extends StatelessWidget {
  const NextLevelInfo(
      {super.key, required this.onPressed, required this.level});
  final Function() onPressed;
  final int level;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(20),
        decoration: getDecoration(color: Colors.green),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('Unlocked level $level!'),
            ElevatedButton(
              onPressed: onPressed,
              child: const Text('continue'),
            ),
          ],
        ),
      ),
    );
  }
}
