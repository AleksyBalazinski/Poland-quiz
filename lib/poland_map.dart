import 'package:flutter/material.dart';
import 'package:poland_quiz/geojson.dart';

class PolandMap extends StatelessWidget {
  const PolandMap({super.key, required this.data});
  final GeoJson data;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: generateVoivodeships(data),
    );
  }
}

class PolygonPainter extends CustomPainter {
  Polygon polygon;
  final Path _path = Path();

  PolygonPainter(this.polygon);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.blueGrey
      ..style = PaintingStyle.fill;

    const int xOffset = 10;
    const int yOffset = 45;
    const int scale = 60;

    _path.moveTo((polygon.vertices[0].coordinates[0] - xOffset) * scale,
        (polygon.vertices[0].coordinates[1] - yOffset) * scale);
    for (int i = 1; i < polygon.vertices.length; i++) {
      _path.lineTo((polygon.vertices[i].coordinates[0] - xOffset) * scale,
          (polygon.vertices[i].coordinates[1] - yOffset) * scale);
    }

    canvas.drawPath(_path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  @override
  bool hitTest(Offset position) {
    return _path.contains(position);
  }
}

class Polygon {
  List<Coordinates> vertices;
  Polygon(this.vertices);
}

List<Widget> generateVoivodeships(GeoJson data) {
  var features = data.features;
  List<Widget> widgets = [];
  for (var feature in features) {
    var geometry = feature.geometry;
    var properties = feature.properties;
    Polygon polygon = Polygon(geometry.coordiateLists[0].coordinateList);

    widgets.add(
      createSingleWidget(0.0, 0.0, () => print(properties.name1),
          const Size(1000, 1000), polygon), // TODO parametrize size
    );
  }

  return widgets;
}

Widget createSingleWidget(double left, double top, Function() onTap,
    Size canvasSize, Polygon polygon) {
  return Positioned(
    left: left,
    top: top,
    child: GestureDetector(
      onTap: onTap,
      child: CustomPaint(size: canvasSize, painter: PolygonPainter(polygon)),
    ),
  );
}
