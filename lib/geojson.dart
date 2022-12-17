import 'dart:convert' show jsonDecode;
import 'package:flutter/services.dart';

class GeoJson {
  final String type;
  final List<Feature> features;

  GeoJson({
    required this.type,
    required this.features,
  });

  factory GeoJson.fromJson(Map<String, dynamic> json) {
    return GeoJson(
      type: json['type'] as String,
      features:
          (json['features'] as List).map((e) => Feature.fromJson(e)).toList(),
    );
  }
}

class Feature {
  final String type;
  final Geometry geometry;
  final Properties properties;

  Feature({
    required this.type,
    required this.geometry,
    required this.properties,
  });

  factory Feature.fromJson(Map<String, dynamic> json) {
    return Feature(
      type: json['type'] as String,
      geometry:
          Geometry.fromJson(json['geometry']), //json['geometry'] as Geometry,
      properties: Properties.fromJson(
          json['properties']), //json['properties'] as Properties,
    );
  }
}

class Geometry {
  final String type;
  final List<CoordinateList> coordiateLists;

  Geometry({
    required this.type,
    required this.coordiateLists,
  });

  factory Geometry.fromJson(Map<String, dynamic> json) {
    return Geometry(
      type: json['type'] as String,
      coordiateLists: (json['coordinates'] as List)
          .map((e) => CoordinateList.fromJson(e))
          .toList(),
    );
  }
}

class CoordinateList {
  final List<Coordinates> coordinateList;

  CoordinateList({required this.coordinateList});

  factory CoordinateList.fromJson(List<dynamic> json) {
    return CoordinateList(
        coordinateList: json.map((e) => Coordinates.fromJson(e)).toList());
  }
}

class Coordinates {
  final List<double> coordinates;

  Coordinates({required this.coordinates});

  factory Coordinates.fromJson(List<dynamic> json) {
    return Coordinates(coordinates: json.map((e) => e as double).toList());
  }
}

class Properties {
  final String gid1;
  final String gid0;
  final String country;
  final String name1;
  final String varname1;
  final String nlName1;
  final String type1;
  final String engtype1;
  final String cc1;
  final String hasc1;
  final String iso1;

  Properties({
    required this.gid1,
    required this.gid0,
    required this.country,
    required this.name1,
    required this.varname1,
    required this.nlName1,
    required this.type1,
    required this.engtype1,
    required this.cc1,
    required this.hasc1,
    required this.iso1,
  });

  factory Properties.fromJson(Map<String, dynamic> json) {
    return Properties(
        gid1: json['GID_1'] as String,
        gid0: json['GID_0'] as String,
        country: json['COUNTRY'] as String,
        name1: json['NAME_1'] as String,
        varname1: json['VARNAME_1'] as String,
        nlName1: json['NL_NAME_1'] as String,
        type1: json['TYPE_1'] as String,
        engtype1: json['ENGTYPE_1'] as String,
        cc1: json['CC_1'] as String,
        hasc1: json['HASC_1'] as String,
        iso1: json['ISO_1'] as String);
  }
}

Future<GeoJson> loadJson(String path) async {
  String data = await rootBundle.loadString(path);
  Map<String, dynamic> parsedJson = jsonDecode(data);
  return GeoJson.fromJson(parsedJson);
}
