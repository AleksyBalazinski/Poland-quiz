import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:poland_quiz/geojson.dart';
import 'package:poland_quiz/poland_map.dart';

class LearnPage extends StatelessWidget {
  const LearnPage({super.key});
  final String _mapPath = 'assets/gadm41_POL_1.json';
  final String _infoPath = 'assets/POL_info.json';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learn page'),
      ),
      body: FutureBuilder<GeoJson>(
        future: loadJson(_mapPath),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error has occurred!'),
            );
          } else if (snapshot.hasData) {
            return LearnMap(
              data: snapshot.data!,
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
  const LearnMap({super.key, required this.data});

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
        Center(
          child: Text(selectedVoivodeship == null
              ? 'nothing selected'
              : selectedVoivodeship!),
        )
      ],
    );
  }
}

class InfoBox extends StatelessWidget {
  final String name;
  const InfoBox({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
