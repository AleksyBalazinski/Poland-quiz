import 'package:flutter/material.dart';
import 'package:poland_quiz/voivodeships.dart';

class PolandMap extends StatelessWidget {
  const PolandMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 30.0,
          top: 30.0,
          child: GestureDetector(
            onTap: () => print('do something'),
            child: CustomPaint(
                size: const Size(500, 500),
                //painter: CurvePainter(Colors.red),
                painter: PolygonPainter(Polygon(Voivodeships.dolnoslaskie))),
          ),
        ),
        Positioned(
          left: 150,
          top: 150,
          child: GestureDetector(
            onTap: () => print('do something small'),
            child: CustomPaint(
              size: const Size(20, 20),
              painter: CurvePainter(Colors.blue),
            ),
          ),
        )
      ],
    );
  }
}

class CurvePainter extends CustomPainter {
  Color _fillColor;
  CurvePainter(this._fillColor);
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = _fillColor
      ..style = PaintingStyle.fill;

    var path = Path()
      ..moveTo(size.width * 0.2, 0)
      ..lineTo(size.width, size.height * 0.2)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class PolygonPainter extends CustomPainter {
  Polygon polygon;
  PolygonPainter(this.polygon);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    var path = Path()
      ..moveTo((polygon.vertices[0][0] - 10) * 60,
          (polygon.vertices[0][1] - 50) * 60);
    for (int i = 1; i < polygon.vertices.length; i++) {
      path.lineTo((polygon.vertices[i][0] - 10) * 60,
          (polygon.vertices[i][1] - 50) * 60);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class Polygon {
  List<List<double>> vertices;
  Polygon(this.vertices);
}
