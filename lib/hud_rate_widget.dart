
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


class CircleProgressView extends StatelessWidget {

  final double rate;

  const CircleProgressView({Key key, this.rate = 0.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    double value = (rate ?? 0) * 100;

    return Container(
      child: CustomPaint(
        painter: _HudRatePainter(rate: rate),
        child: Container(
          alignment: Alignment.center,
          width: 40,
          height: 40,
          child: Text("${value.toStringAsFixed(1)}%",style: TextStyle(color: Colors.white,fontSize: 10),),
        ),
      ),
    );
  }
}



class _HudRatePainter extends CustomPainter{

  final double rate;

  _HudRatePainter({this.rate = 0.0});

  @override
  void paint(Canvas canvas, Size size) {

    var rect = Rect.fromLTWH(0, 0, size.width, size.height);

    var _paintBg = Paint()
      ..style = PaintingStyle.fill
        ..isAntiAlias = true
        ..color = Colors.white10
        ..strokeWidth = 2
        ..shader = SweepGradient(colors: [Colors.white, Colors.white], startAngle: 0, endAngle: pi * 2,).createShader(rect);

    canvas.drawArc(rect, 0, pi * 2, true, _paintBg);

    var _paint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true
      ..color = Colors.white70;

    double value = pi * 2 * (rate ?? 0.0);
    canvas.drawArc(rect, 0, value, true, _paint);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}


