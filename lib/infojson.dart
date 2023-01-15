import 'dart:convert' show jsonDecode;
import 'package:flutter/services.dart';

class VoivodeshipInfo {
  final int areaKmSq;
  final int populationK;
  final String voivodeSeat;
  final String sejmikSeat;
  final List<String> otherCities;
  final String flagPath;

  const VoivodeshipInfo({
    required this.areaKmSq,
    required this.populationK,
    required this.voivodeSeat,
    required this.sejmikSeat,
    required this.otherCities,
    required this.flagPath,
  });

  factory VoivodeshipInfo.fromJson(Map<String, dynamic> json) {
    return VoivodeshipInfo(
      areaKmSq: json['area'],
      populationK: json['population'],
      voivodeSeat: json['voivode_seat'],
      sejmikSeat: json['sejmik_seat'],
      otherCities:
          (json['other_cities'] as List).map((e) => e.toString()).toList(),
      flagPath: json['flag_path'],
    );
  }
}

class InfoJson {
  final Map<String, VoivodeshipInfo> voivodeships;

  InfoJson({required this.voivodeships});

  factory InfoJson.fromJson(Map<String, dynamic> json) {
    return InfoJson(
        voivodeships: json.map(
      (key, value) => MapEntry(key, VoivodeshipInfo.fromJson(value)),
    ));
  }
}

Future<InfoJson> loadInfoJson(String path) async {
  String data = await rootBundle.loadString(path);
  Map<String, dynamic> parsedJson = jsonDecode(data);
  return InfoJson.fromJson(parsedJson);
}
