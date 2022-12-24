import 'package:proj4dart/proj4dart.dart';
import 'package:flutter/material.dart';

class PolygonPainter extends CustomPainter {
  Polygon polygon;
  Color fillColor;
  final Path _path = Path();

  PolygonPainter({required this.polygon, required this.fillColor});

  @override
  void paint(Canvas canvas, Size size) {
    var paintFill = Paint()
      ..color = fillColor // Colors.blueGrey
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
    return true;
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
