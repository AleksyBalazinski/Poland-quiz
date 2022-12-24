import 'dart:math';

import 'package:flutter/material.dart';
import 'package:poland_quiz/decoration.dart';
import 'package:poland_quiz/polygon_painter.dart';
import 'package:poland_quiz/geojson.dart';
import 'package:proj4dart/proj4dart.dart';

class PolandMap extends StatefulWidget {
  const PolandMap({super.key, required this.data, required this.onSelection});
  final GeoJson data;
  final Function(String) onSelection;

  @override
  State<PolandMap> createState() => _PolandMapState();
}

class _PolandMapState extends State<PolandMap> {
  String? selectedVoivodeship;
  late List<Feature> features;
  late Iterable<Coordinates> allCoordinates;
  var tuple = ProjectionTuple(
    fromProj: Projection.WGS84,
    toProj: Projection.GOOGLE,
  );
  late Point minLong;
  late Point maxLong;
  late Point minLat;
  late Point maxLat;

  @override
  void initState() {
    super.initState();

    features = widget.data.features;
    allCoordinates = features
        .expand((feature) => feature.geometry.coordiateLists[0].coordinateList);
    minLong = tuple.forward(allCoordinates
        .reduce(
            (cur, next) => cur.coordinates.x < next.coordinates.x ? cur : next)
        .coordinates);

    maxLong = tuple.forward(allCoordinates
        .reduce(
            (cur, next) => cur.coordinates.x > next.coordinates.x ? cur : next)
        .coordinates);

    minLat = tuple.forward(allCoordinates
        .reduce(
            (cur, next) => cur.coordinates.y < next.coordinates.y ? cur : next)
        .coordinates);

    maxLat = tuple.forward(allCoordinates
        .reduce(
            (cur, next) => cur.coordinates.y > next.coordinates.y ? cur : next)
        .coordinates);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = 300;
    const double cornerRadius = 10;
    const double margin = 20;
    double canvasWidth = width - 2 * margin;
    double canvasHeight = height;
    double scale = min(canvasHeight, canvasWidth) /
        max(maxLat.y - minLat.y, maxLong.x - minLong.x);
    double leftOffset = (canvasWidth -
            (toScreenCoordinates(maxLong, minLong.x, maxLat.y, scale).x -
                toScreenCoordinates(minLong, minLong.x, maxLat.y, scale).x)) /
        2;

    double topOffset = (canvasHeight +
            (toScreenCoordinates(maxLat, minLong.x, maxLat.y, scale).y -
                toScreenCoordinates(minLat, minLong.x, maxLat.y, scale).y)) /
        2;

    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.all(margin),
      width: width,
      height: height,
      decoration: getDecoration(),
      child: InteractiveViewer(
        child: Stack(
          children: <Widget>[
            for (var feature in features)
              () {
                var geometry = feature.geometry;
                var properties = feature.properties;

                var polygon = Polygon(geometry.coordiateLists[0].coordinateList
                    .map((c) => tuple.forward(c.coordinates))
                    .map((p) =>
                        toScreenCoordinates(p, minLong.x, maxLat.y, scale))
                    .toList());

                return Voivodeship(
                  left: leftOffset,
                  top: topOffset,
                  onTap: () {
                    print(properties.name1);
                    selectedVoivodeship = properties.name1;
                    setState(() {});
                    widget.onSelection(properties.name1);
                  },
                  polygon: polygon,
                  isSelected: selectedVoivodeship == properties.name1,
                );
              }()
          ],
        ),
      ),
    );
  }
}

class Voivodeship extends StatelessWidget {
  final double left;
  final double top;
  final Function() onTap;
  final Polygon polygon;
  final bool isSelected;
  const Voivodeship({
    super.key,
    required this.left,
    required this.top,
    required this.onTap,
    required this.polygon,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      child: GestureDetector(
        onTap: onTap,
        child: CustomPaint(
          size: const Size(double.maxFinite, double.maxFinite),
          painter: PolygonPainter(
              polygon: polygon,
              fillColor: isSelected ? Colors.orange : Colors.blueGrey),
        ),
      ),
    );
  }
}

Point toScreenCoordinates(
    Point coordinates, double minLong, double maxLat, double scale) {
  return Point(
    x: (coordinates.x - minLong) * scale,
    y: (maxLat - coordinates.y) * scale,
  );
}
