import 'package:flutter/material.dart';
import 'package:poland_quiz/decoration.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
            Text(
              AppLocalizations.of(context)!.gameOver,
              style: const TextStyle(fontSize: 20),
            ),
            ElevatedButton(
              onPressed: onPressed,
              child: Text(AppLocalizations.of(context)!.tryAgain),
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
            Text(
              AppLocalizations.of(context)!.wrongAns,
              style: const TextStyle(fontSize: 20),
            ),
            ElevatedButton(
              onPressed: onPressed,
              child: Text(AppLocalizations.of(context)!.cont),
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
            Text(AppLocalizations.of(context)!.correctAns),
            ElevatedButton(
              onPressed: onPressed,
              child: Text(AppLocalizations.of(context)!.cont),
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
            Text(AppLocalizations.of(context)!.unlockedLevel(level)),
            ElevatedButton(
              onPressed: onPressed,
              child: Text(AppLocalizations.of(context)!.cont),
            ),
          ],
        ),
      ),
    );
  }
}
