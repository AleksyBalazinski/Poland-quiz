import 'dart:math';

import 'package:flutter/material.dart';
import 'package:poland_quiz/geojson.dart';
import 'package:proj4dart/proj4dart.dart';

class PolandMap extends StatelessWidget {
  const PolandMap({super.key, required this.data});
  final GeoJson data;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = 300;
    const double cornerRadius = 10;
    const double margin = 20;
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.all(margin),
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.blue.shade200,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(cornerRadius),
          topRight: Radius.circular(cornerRadius),
          bottomLeft: Radius.circular(cornerRadius),
          bottomRight: Radius.circular(cornerRadius),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
          ),
        ],
      ),
      child: InteractiveViewer(
        child: Stack(
          children: generateVoivodeships(data, width - 2 * margin, height),
        ),
      ),
    );
  }
}

class PolygonPainter extends CustomPainter {
  Polygon polygon;
  final Path _path = Path();

  PolygonPainter(this.polygon);

  @override
  void paint(Canvas canvas, Size size) {
    var paintFill = Paint()
      ..color = Colors.blueGrey
      ..style = PaintingStyle.fill;
    var paintBorder = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    _path.moveTo(polygon.vertices[0].x, polygon.vertices[0].y);
    for (int i = 1; i < polygon.vertices.length; i++) {
      _path.lineTo(polygon.vertices[i].x, polygon.vertices[i].y);
    }

    canvas.drawPath(_path, paintBorder);
    canvas.drawPath(_path, paintFill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  @override
  bool hitTest(Offset position) {
    return _path.contains(position);
  }
}

class Polygon {
  List<Point> vertices; // vertices in screen coordinates
  Polygon(this.vertices);
}

List<Widget> generateVoivodeships(
    GeoJson data, double canvasWidth, double canvasHeight) {
  var features = data.features;
  List<Widget> widgets = [];
  var allCoordinates = features
      .expand((feature) => feature.geometry.coordiateLists[0].coordinateList);

  var tuple = ProjectionTuple(
    fromProj: Projection.WGS84,
    toProj: Projection.GOOGLE,
  );

  Point minLong = tuple.forward(
    allCoordinates
        .reduce(
          (cur, next) => cur.coordinates.x < next.coordinates.x ? cur : next,
        )
        .coordinates,
  );

  Point maxLong = tuple.forward(
    allCoordinates
        .reduce(
          (cur, next) => cur.coordinates.x > next.coordinates.x ? cur : next,
        )
        .coordinates,
  );

  Point minLat = tuple.forward(
    allCoordinates
        .reduce(
          (cur, next) => cur.coordinates.y < next.coordinates.y ? cur : next,
        )
        .coordinates,
  );

  Point maxLat = tuple.forward(
    allCoordinates
        .reduce(
          (cur, next) => cur.coordinates.y > next.coordinates.y ? cur : next,
        )
        .coordinates,
  );

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

  for (var feature in features) {
    var geometry = feature.geometry;
    var properties = feature.properties;

    Polygon polygon = Polygon(geometry.coordiateLists[0].coordinateList
        .map(
          (c) => tuple.forward(c.coordinates),
        )
        .map(
          (p) => toScreenCoordinates(
            p,
            minLong.x,
            maxLat.y,
            scale,
          ),
        )
        .toList());

    widgets.add(
      createSingleWidget(
        leftOffset,
        topOffset,
        () => print(properties.name1),
        polygon,
      ),
    );
  }

  return widgets;
}

Point toScreenCoordinates(
    Point coordinates, double minLong, double maxLat, double scale) {
  return Point(
    x: (coordinates.x - minLong) * scale,
    y: (maxLat - coordinates.y) * scale,
  );
}

Widget createSingleWidget(
    double left, double top, Function() onTap, Polygon polygon) {
  return Positioned(
    left: left,
    top: top,
    child: GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        size: const Size(double.maxFinite, double.maxFinite),
        painter: PolygonPainter(polygon),
      ),
    ),
  );
}
