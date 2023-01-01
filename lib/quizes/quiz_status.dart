import 'package:flutter/material.dart';
import 'package:poland_quiz/decoration.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QuizStatus extends StatelessWidget {
  const QuizStatus({
    Key? key,
    required int pointsCount,
    required int level,
    required int hp,
  })  : _pointsCount = pointsCount,
        _level = level,
        _hp = hp,
        super(key: key);

  final int _pointsCount;
  final int _level;
  final int _hp;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: getDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            AppLocalizations.of(context)!
                .pointsCounter(_pointsCount, _level * 3),
            style: const TextStyle(fontSize: 20),
          ),
          Text(
            AppLocalizations.of(context)!.level(_level),
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
    );
  }
}
