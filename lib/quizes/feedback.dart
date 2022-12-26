import 'package:flutter/material.dart';
import 'package:poland_quiz/decoration.dart';

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
