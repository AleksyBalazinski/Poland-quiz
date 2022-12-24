import 'package:flutter/material.dart';
import 'package:poland_quiz/decoration.dart';
import 'package:poland_quiz/geojson.dart';
import 'package:poland_quiz/infojson.dart';
import 'package:poland_quiz/poland_map.dart';

class LearnPage extends StatelessWidget {
  const LearnPage({super.key});
  final String _mapPath = 'assets/gadm41_POL_1.json';
  final String _infoPath = 'assets/pol_info.json';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learn page'),
      ),
      body: FutureBuilder(
        future: Future.wait([loadGeoJson(_mapPath), loadInfoJson(_infoPath)]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error has occurred!'),
            );
          } else if (snapshot.hasData) {
            return LearnMap(
              data: snapshot.data![0],
              info: snapshot.data![1],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class LearnMap extends StatefulWidget {
  final GeoJson data;
  final InfoJson info;
  const LearnMap({super.key, required this.data, required this.info});

  @override
  State<LearnMap> createState() => _LearnMapState();
}

class _LearnMapState extends State<LearnMap> {
  String? selectedVoivodeship;

  void _setSelectedVoivodeship(String voiovodeship) {
    setState(() => selectedVoivodeship = voiovodeship);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PolandMap(
          data: widget.data,
          onSelection: _setSelectedVoivodeship,
        ),
        selectedVoivodeship == null
            ? const Expanded(
                child: EmptyInfoBox(),
              )
            : Expanded(
                child:
                    InfoBox(selected: selectedVoivodeship!, info: widget.info),
              ),
      ],
    );
  }
}

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
      child: Row(
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
