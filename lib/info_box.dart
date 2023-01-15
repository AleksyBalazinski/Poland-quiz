import 'package:flutter/material.dart';
import 'package:poland_quiz/decoration.dart';
import 'package:poland_quiz/infojson.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InfoBox extends StatelessWidget {
  final String selected;
  final InfoJson info;

  const InfoBox({super.key, required this.selected, required this.info});

  @override
  Widget build(BuildContext context) {
    const double margin = 20;
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.all(margin),
      decoration: getDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
            child: Text(
              selected,
              style: const TextStyle(fontSize: 25),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(getArea(context, info, selected),
                  style: const TextStyle(fontSize: 20)),
              Text(getPopulation(context, info, selected),
                  style: const TextStyle(fontSize: 20)),
              Text(getVoivodeSeat(context, info, selected),
                  style: const TextStyle(fontSize: 20)),
              Text(getSejmikSeat(context, info, selected),
                  style: const TextStyle(fontSize: 20)),
            ],
          )
        ],
      ),
    );
  }
}

String getArea(BuildContext context, InfoJson info, String voivodeship) {
  var area = info.voivodeships[voivodeship.toLowerCase()]!.areaKmSq;
  return AppLocalizations.of(context)!.area(area);
}

String getPopulation(BuildContext context, InfoJson info, String voivodeship) {
  int population = info.voivodeships[voivodeship.toLowerCase()]!.populationK;
  return AppLocalizations.of(context)!.population(population);
}

String getSejmikSeat(BuildContext context, InfoJson info, String voivodeship) {
  var sejmikSeat = info.voivodeships[voivodeship.toLowerCase()]!.sejmikSeat;
  return AppLocalizations.of(context)!.sejmikSeat(sejmikSeat);
}

String getVoivodeSeat(BuildContext context, InfoJson info, String voivodeship) {
  var voivodeSeat = info.voivodeships[voivodeship.toLowerCase()]!.voivodeSeat;
  return AppLocalizations.of(context)!.voivodeSeat(voivodeSeat);
}

class EmptyInfoBox extends StatelessWidget {
  const EmptyInfoBox({super.key});

  @override
  Widget build(BuildContext context) {
    const double margin = 20;
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.all(margin),
      decoration: getDecoration(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            AppLocalizations.of(context)!.touchTheMap,
            style: const TextStyle(fontSize: 15),
          ),
        ),
      ),
    );
  }
}
