import 'package:flutter/material.dart';

class DataTransferAnimationWidget extends StatefulWidget {
  final IconData iconLeft;
  final IconData iconRight;

  final int speed;
  final int columns;
  final double iconSize;
  final double bubbleSize;
  Color defaultcolor = Colors.blueGrey;
  Color highlightColor = Colors.blue;

  DataTransferAnimationWidget(this.iconLeft, this.iconRight,
      {this.speed = 700,
      this.columns = 8,
      this.iconSize = 20,
      this.bubbleSize = 5,
      pdefaultcolor,
      phighlightColor}) {
    if (pdefaultcolor == null) {
      this.defaultcolor = Colors.blue.shade100;
    }
    if (phighlightColor == null) {
      this.highlightColor = Colors.blue.shade400;
    }
  }

  @override
  _DataTransferAnimationWidgetState createState() =>
      _DataTransferAnimationWidgetState();
}

class _DataTransferAnimationWidgetState
    extends State<DataTransferAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<int> _animation;

  late Widget defaultBubble;
  late Widget midBubble;
  late Widget highlightBubble;

  Widget x1 = Container(
    padding: EdgeInsets.all(8),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.blue,
    ),
    width: 5.0,
    height: 5.0,
  );

  Widget x2 = Container(
    padding: EdgeInsets.all(8),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.blue[300],
    ),
    width: 5.0,
    height: 5.0,
  );

  Widget x3 = Container(
    padding: EdgeInsets.all(8),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.blue[100],
    ),
    width: 5.0,
    height: 5.0,
  );

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: widget.speed));

    _animation = IntTween(begin: 0, end: widget.columns - 1)
        .animate(_animationController);

    _animationController.repeat(reverse: false);

    defaultBubble = bubble(widget.defaultcolor);
    midBubble = bubble(
        Color.lerp(widget.defaultcolor, widget.highlightColor, 0.5) ??
            Colors.red);
    highlightBubble = bubble(widget.highlightColor);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    _animationController.dispose();
  }

  Widget bubble(Color _color) {
    return Container(
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _color,
      ),
      width: widget.bubbleSize,
      height: widget.bubbleSize,
    );
  }

  Widget bubbles() {
    return AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          Map<String, List<Widget>> _bubbles = {'up': [], 'down': []};

          List<int> chk = [
            _animation.value,
            // _animation.value + 5,
            // _animation.value - 5
          ];

          for (int i = 0; i < widget.columns; i++) {
            if (chk.contains(i)) {
              _bubbles['up']!.add(highlightBubble);
            } else if (chk.contains(i + 1)) {
              _bubbles['up']!.add(midBubble);
            } else {
              _bubbles['up']!.add(defaultBubble);
            }
            if (widget.columns - i - 1 == _animation.value) {
              _bubbles['down']!.add(highlightBubble);
            } else if (widget.columns - i - 2 == _animation.value) {
              _bubbles['down']!.add(midBubble);
            } else {
              _bubbles['down']!.add(defaultBubble);
            }
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //Text(_animation.value.toString()),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: _bubbles['up'] ?? [],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: _bubbles['down'] ?? [],
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
              flex: 1, child: Icon(widget.iconLeft, size: widget.iconSize)),
          Expanded(flex: 2, child: bubbles()),
          Expanded(
              flex: 1, child: Icon(widget.iconRight, size: widget.iconSize)),
        ],
      ),
    );
  }
}
