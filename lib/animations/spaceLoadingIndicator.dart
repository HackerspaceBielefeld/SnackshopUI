import 'dart:math';
import 'package:flutter/material.dart';

class SpaceLoadingIndicator extends StatefulWidget {
  _SpaceLoadingIndicatorState createState() => _SpaceLoadingIndicatorState();
}

class _SpaceLoadingIndicatorState extends State<SpaceLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  late Animation<double> _animation;

  @override
  void initState() {
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _animation =
        CurveTween(curve: Curves.easeInOut).animate(_rotationController)
          ..addListener(
            () => setState(() {}),
          );

    _rotationController.repeat();

    super.initState();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Matrix4 transform = Matrix4.rotationZ(_animation.value * pi * 2.0);

    return Center(
      child: SizedBox(
        width: 200,
        height: 200,
        child: Stack(
          children: <Widget>[
            Image(image: AssetImage('assets/loading/loadingback.png')),
            Transform(
              transform: transform,
              alignment: Alignment.center,
              child:
                  Image(image: AssetImage('assets/loading/loadingfront.png')),
            ),
          ],
        ),
      ),
    );
  }
}
