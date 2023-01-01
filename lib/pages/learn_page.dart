import 'package:flutter/material.dart';
import 'package:poland_quiz/geojson.dart';
import 'package:poland_quiz/infojson.dart';
import 'package:poland_quiz/poland_map.dart';
import 'package:poland_quiz/info_box.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LearnPage extends StatelessWidget {
  const LearnPage({super.key, required this.geoJson, required this.infoJson});
  final GeoJson geoJson;
  final InfoJson infoJson;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.learning),
      ),
      body: LearnMap(data: geoJson, info: infoJson),
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
