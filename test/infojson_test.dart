import 'package:flutter_test/flutter_test.dart';
import 'package:poland_quiz/infojson.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  InfoJson infoJson = await loadInfoJson('assets/test/test_info.json');
  var voivodeships = infoJson.voivodeships;
  test('region test1', () {
    expect(voivodeships['test1']!.areaKmSq, 123);
    expect(voivodeships['test1']!.populationK, 1234);
    expect(voivodeships['test1']!.voivodeSeat, "CapitalV");
    expect(voivodeships['test1']!.sejmikSeat, "CapitalS");
    expect(voivodeships['test1']!.otherCities,
        equals(["Other City 11", "Other City 12"]));
  });
  test('region test2', () {
    expect(voivodeships['test2']!.areaKmSq, 321);
    expect(voivodeships['test2']!.populationK, 4321);
    expect(voivodeships['test2']!.voivodeSeat, "Capital2");
    expect(voivodeships['test2']!.sejmikSeat, "Capital2");
    expect(voivodeships['test2']!.otherCities,
        equals(["Other City 21", "Other City 22"]));
  });
  test('region test3', () {
    expect(voivodeships['test3']!.areaKmSq, 0);
    expect(voivodeships['test3']!.populationK, 0);
    expect(voivodeships['test3']!.voivodeSeat, "Capital3");
    expect(voivodeships['test3']!.sejmikSeat, "Capital3");
    expect(voivodeships['test3']!.otherCities, equals([]));
  });
}
