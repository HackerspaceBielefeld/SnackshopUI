import 'package:flutter/material.dart';

typedef KeypadKeyPressCallback = Function(String);

class KeypadButton extends StatelessWidget {
  final String char;
  final KeypadKeyPressCallback cb;

  KeypadButton(this.char, this.cb);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: InkWell(
      onTap: () {
        cb(char);
      },
      child: Center(
          child: Text(
        char,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      )),
    ));
  }
}

class KeypadWidget extends StatelessWidget {
  KeypadKeyPressCallback cb;

  KeypadWidget(this.cb);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        //childAspectRatio: 1,
        children: [
          KeypadButton('1', cb),
          KeypadButton('2', cb),
          KeypadButton('3', cb),
          KeypadButton('4', cb),
          KeypadButton('5', cb),
          KeypadButton('6', cb),
          KeypadButton('7', cb),
          KeypadButton('8', cb),
          KeypadButton('9', cb),
          KeypadButton('*', cb),
          KeypadButton('0', cb),
          KeypadButton('#', cb),
        ],
      ),
    );
  }

  @override
  Widget buildx(BuildContext context) {
    return Table(
      children: [
        TableRow(children: [
          ElevatedButton(onPressed: () {}, child: Text('1')),
          ElevatedButton(onPressed: () {}, child: Text('2')),
          ElevatedButton(onPressed: () {}, child: Text('3')),
        ]),
        TableRow(children: [
          ElevatedButton(onPressed: () {}, child: Text('4')),
          ElevatedButton(onPressed: () {}, child: Text('5')),
          ElevatedButton(onPressed: () {}, child: Text('6')),
        ]),
        TableRow(children: [
          ElevatedButton(onPressed: () {}, child: Text('7')),
          ElevatedButton(onPressed: () {}, child: Text('8')),
          ElevatedButton(onPressed: () {}, child: Text('9')),
        ]),
        TableRow(children: [
          ElevatedButton(onPressed: () {}, child: Text('*')),
          ElevatedButton(onPressed: () {}, child: Text('0')),
          ElevatedButton(onPressed: () {}, child: Text('#')),
        ]),
      ],
    );
  }
}
