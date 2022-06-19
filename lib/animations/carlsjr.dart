import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

enum CarlsStarMood { pissed, normal, happy }

class CarlsStar extends CustomPainter {
  Color backColor = Color(0xffc00e0d);
  Color innerColor = Color(0xfff4bb34);
  Color outerColor = Color(0xff91221f);

  CarlsStarMood mood = CarlsStarMood.pissed;

  @override
  void paint(Canvas canvas, Size size) {
    double radiusOuter;
    double radiusInner;
    radiusOuter = (size.width / 2) * 0.90;
    radiusInner = radiusOuter * 0.6;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = backColor);

    Offset center = Offset(size.width / 2, size.height / 2);

    List<List<double>> star = [
      [radiusOuter, -10],
      [radiusOuter, 10],
      [radiusInner, 33],
      [radiusOuter, 60],
      [radiusOuter, 80],
      [radiusInner, 105],
      [radiusOuter, 133],
      [radiusOuter, 155],
      [radiusInner, 180],
      [radiusOuter, 205],
      [radiusOuter, 228],
      [radiusInner, 254],
      [radiusOuter, 280],
      [radiusOuter, 300],
      [radiusInner, 324],
    ];

    Path p = Path();

    List<Offset> points = [];

    star.forEach((el) {
      points.add(center -
          Offset(el[0] * sin(el[1] * pi / 180), el[0] * cos(el[1] * pi / 180)));
    });

    p.addPolygon(points, true);
    print(points);
    canvas.drawPath(
        p,
        Paint()
          ..color = innerColor
          ..style = PaintingStyle.fill
          ..strokeWidth = 1);
    canvas.drawPath(
        p,
        Paint()
          ..color = outerColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = size.width * 0.05);

    canvas.drawCircle(Offset(size.width * 0.4, size.height * 0.42),
        size.width * 0.025, Paint()..color = outerColor);
    canvas.drawCircle(Offset(size.width * 0.6, size.height * 0.42),
        size.width * 0.025, Paint()..color = outerColor);

    Paint eyebrowP = Paint()
      ..color = outerColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.02;

    Paint mouthP = Paint()
      ..color = outerColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.02;

    num degToRad(num deg) => deg * (pi / 180.0);

    Path mouth = Path();
    mouth.moveTo(center.dx - 100, center.dy);

    if (mood == CarlsStarMood.pissed) {
      canvas.drawLine(Offset(size.width * 0.4, size.height * 0.35),
          Offset(size.width * 0.45, size.height * 0.40), eyebrowP);
      canvas.drawLine(Offset(size.width * 0.60, size.height * 0.35),
          Offset(size.width * 0.55, size.height * 0.40), eyebrowP);
      mouth.arcTo(
          Rect.fromCenter(
              center: center + Offset(0, size.height / 6),
              width: size.width / 6,
              height: size.width / 6),
          degToRad(225).toDouble(),
          degToRad(90).toDouble(),
          true);
    } else if (mood == CarlsStarMood.normal) {
      canvas.drawLine(Offset(size.width * 0.35, size.height * 0.35),
          Offset(size.width * 0.45, size.height * 0.35), eyebrowP);
      canvas.drawLine(Offset(size.width * 0.65, size.height * 0.35),
          Offset(size.width * 0.55, size.height * 0.35), eyebrowP);
      mouth.arcTo(
          Rect.fromCenter(
              center: center + Offset(0, size.height / 10),
              width: size.width / 6,
              height: size.width / 100),
          degToRad(225).toDouble(),
          degToRad(90).toDouble(),
          true);
    } else if (mood == CarlsStarMood.happy) {
      canvas.drawLine(Offset(size.width * 0.35, size.height * 0.40),
          Offset(size.width * 0.40, size.height * 0.35), eyebrowP);
      canvas.drawLine(Offset(size.width * 0.6, size.height * 0.35),
          Offset(size.width * 0.65, size.height * 0.40), eyebrowP);
      mouth.arcTo(
          Rect.fromCenter(
              center: center + Offset(0, size.height / 30),
              width: size.width / 6,
              height: size.width / 6),
          degToRad(45).toDouble(),
          degToRad(90).toDouble(),
          true);
    }

    canvas.drawPath(mouth, mouthP);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class CarlsScreensaferAnimation extends StatefulWidget {
  @override
  _CarlsScreensaferAnimationState createState() =>
      _CarlsScreensaferAnimationState();
}

class _CarlsScreensaferAnimationState extends State<CarlsScreensaferAnimation>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacementNamed('/');
    });
    return Center(
      child: CustomPaint(
        painter: CarlsStar(),
        child: SizedBox(
          height: 300,
          width: 300,
        ),
      ),
    );
  }
}

class CarlsScreensafer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CarlsScreensaferAnimation(),
    );
  }
}
