import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class EurNote extends StatelessWidget {
  final int value;
  final bool front;
  final bool enabled;
  final int imgwidth;
  final EdgeInsets padding;

  EurNote(int value,
      {bool front = true,
      bool enabled = true,
      int imgwidth = 40,
      EdgeInsets padding =
          const EdgeInsets.symmetric(vertical: 0, horizontal: 10)})
      : value = value,
        front = front,
        enabled = enabled,
        imgwidth = imgwidth,
        padding = padding;

  @override
  Widget build(BuildContext context) {
    //return Text(value.toString() + '€');
    String assetstr = "assets/eur_notes/" +
        (enabled ? "enabled" : "disabled") +
        '/' +
        value.toString() +
        "_" +
        (front ? 'front' : 'back') +
        ".png";
    Widget result;

    if (!enabled) {
      result = Stack(
        children: [
          Image(width: imgwidth.toDouble(), image: AssetImage(assetstr)),
          Icon(MdiIcons.close, size: 20, color: Colors.redAccent),
        ],
      );
    } else {
      result = Image(width: imgwidth.toDouble(), image: AssetImage(assetstr));
    }

    /* Crash: Siehe NOTICE im assests ordner
    if (!enabled) {
      result = Stack(
        children: [
          Container(
              foregroundDecoration: BoxDecoration(
                color: Colors.grey,
                backgroundBlendMode: BlendMode.saturation,
              ),
              child: Image(
                  width: imgwidth.toDouble(), image: AssetImage(assetstr))),
          Icon(MdiIcons.close, size: 20, color: Colors.redAccent),
        ],
      );
    } else {
      result = Image(width: imgwidth.toDouble(), image: AssetImage(assetstr));
    }
    */

    return Padding(
      padding: padding,
      child: result,
    );
  }
}
