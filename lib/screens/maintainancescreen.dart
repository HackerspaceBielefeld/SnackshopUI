import 'package:flutter/material.dart';
import 'package:spacebisnackshop/animations/carlsjr.dart';

class MaintainanceScreensafer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CarlsScreensaferAnimation(),
          Text('WARTUNGSMODUS!',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.red, fontSize: 40))
        ],
      ),
    );
  }
}
