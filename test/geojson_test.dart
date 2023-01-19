import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:poland_quiz/geojson.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GeoJson geoJson = await loadGeoJson('assets/test/test_geo.json');
  var features = geoJson.features;
  var type = geoJson.type;

  test('geojson test', () {
    expect(features.length, 2);
    expect(type, "FeatureCollection");
  });

  test('Dolnoslaskie test', () {
    var type = features[0].type;
    var geometry = features[0].geometry;
    expect(type, "Feature");
    expect(geometry.type, "Polygon");
    var coordinateLists = geometry.coordiateLists;
    var coordinateList = coordinateLists[0];
    expect(coordinateLists.length, 1);
    expect(coordinateList.coordinateList.length, 3);

    expect(coordinateList.coordinateList[0].coordinates.x, 15.0124);
    expect(coordinateList.coordinateList[0].coordinates.y, 51.3634);

    expect(coordinateList.coordinateList[1].coordinates.x, 14.8227);
    expect(coordinateList.coordinateList[1].coordinates.y, 50.871);

    expect(coordinateList.coordinateList[2].coordinates.x, 15.1695);
    expect(coordinateList.coordinateList[2].coordinates.y, 51.0206);

    var properties = features[0].properties;
    expect(properties.gid0, "POL");
    expect(properties.gid1, "POL.1_1");
    expect(properties.country, "Poland");
    expect(properties.name1, "Dolnośląskie");
    expect(properties.varname1, "NA");
    expect(properties.nlName1, "NA");
    expect(properties.type1, "Województwo");
    expect(properties.engtype1, "Voivodeship");
    expect(properties.cc1, "02");
    expect(properties.hasc1, "NA");
    expect(properties.iso1, "NA");
  });

  test('Kujawsko-Pomorskie', () {
    var type = features[1].type;
    var geometry = features[1].geometry;
    expect(type, "Feature");
    expect(geometry.type, "Polygon");
    var coordinateLists = geometry.coordiateLists;
    var coordinateList = coordinateLists[0];
    expect(coordinateLists.length, 1);
    expect(coordinateList.coordinateList.length, 3);

    expect(coordinateList.coordinateList[0].coordinates.x, 19.2618);
    expect(coordinateList.coordinateList[0].coordinates.y, 52.4357);

    expect(coordinateList.coordinateList[1].coordinates.x, 19.2592);
    expect(coordinateList.coordinateList[1].coordinates.y, 52.4426);

    expect(coordinateList.coordinateList[2].coordinates.x, 19.3782);
    expect(coordinateList.coordinateList[2].coordinates.y, 52.5686);

    var properties = features[1].properties;
    expect(properties.gid0, "POL");
    expect(properties.gid1, "POL.2_1");
    expect(properties.country, "Poland");
    expect(properties.name1, "Kujawsko-Pomorskie");
    expect(properties.varname1, "NA");
    expect(properties.nlName1, "NA");
    expect(properties.type1, "Województwo");
    expect(properties.engtype1, "Voivodeship");
    expect(properties.cc1, "04");
    expect(properties.hasc1, "NA");
    expect(properties.iso1, "NA");
  });
}
