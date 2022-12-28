import 'package:flutter/material.dart';
import 'package:poland_quiz/decoration.dart';
import 'package:poland_quiz/infojson.dart';

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
              Text(getArea(info, selected),
                  style: const TextStyle(fontSize: 20)),
              Text(getPopulation(info, selected),
                  style: const TextStyle(fontSize: 20)),
              Text(getVoivodeSeat(info, selected),
                  style: const TextStyle(fontSize: 20)),
              Text(getSejmikSeat(info, selected),
                  style: const TextStyle(fontSize: 20)),
            ],
          )
        ],
      ),
    );
  }
}

String getArea(InfoJson info, String voivodeship) {
  var area = info.voivodeships[voivodeship.toLowerCase()]!.areaKmSq;
  String unit = "thousand kmSq";
  return "Area: ${area ~/ 1000} $unit";
}

String getPopulation(InfoJson info, String voivodeship) {
  double population =
      info.voivodeships[voivodeship.toLowerCase()]!.populationK.toDouble();
  String unit;
  if (population > 1000) {
    unit = "million";
    population /= 1000;
  } else {
    unit = "thousand";
  }
  return "Population: ${population.toStringAsFixed(2)} $unit";
}

String getSejmikSeat(InfoJson info, String voivodeship) {
  var sejmikSeat = info.voivodeships[voivodeship.toLowerCase()]!.sejmikSeat;
  return "Sejmik seat: $sejmikSeat";
}

String getVoivodeSeat(InfoJson info, String voivodeship) {
  var voivodeSeat = info.voivodeships[voivodeship.toLowerCase()]!.voivodeSeat;
  return "Voivode seat: $voivodeSeat";
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
      child: const Center(
        child: Text(
          'Touch the map to display information about the selected voivodeship',
          style: TextStyle(fontSize: 15),
        ),
      ),
    );
  }
}
