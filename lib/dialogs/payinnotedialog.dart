import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacebisnackshop/providers/noteprovider.dart';
import 'package:spacebisnackshop/widgets/datatransferanimationwidget.dart';
import 'package:widget_circular_animator/widget_circular_animator.dart';

class PayInNoteDialog extends StatefulWidget {
  @override
  _PayInNoteDialogState createState() => _PayInNoteDialogState();
}

class _PayInNoteDialogState extends State<PayInNoteDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> ani;

  late Timer closeTimer;
  bool closeTimerActive = false;
  int autoclose = 30;

  NoteProviderState? lastState;

  @override
  void initState() {
    super.initState();

    autoclose = 15;
    closeTimerActive = false;

    closeTimer = Timer.periodic(Duration(seconds: 1), (t) {
      if (closeTimerActive) {
        autoclose--;
        if (autoclose <= 0) {
          closeTimerActive = false;
          t.cancel();
          Navigator.pop(context, lastState);
        }
        setState(() {});
      }
    });

    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
      reverseDuration: Duration(milliseconds: 1000),
    );

    ani = Tween<double>(begin: 0, end: 1).animate(controller);
  }

  @override
  void dispose() {
    closeTimer.cancel();
    controller.dispose();
    super.dispose();
  }

  Widget autocloseBtn() {
    int remainMin = (autoclose / 60).floor();
    int remainSec = (autoclose % 60);

    return TextButton.icon(
        style: TextButton.styleFrom(primary: Colors.blue),
        onPressed: () {
          Navigator.pop(context, lastState);
        },
        icon: Icon(Icons.close),
        label: Text('Schließen (' +
            remainMin.toString().padLeft(2, '0') +
            ':' +
            remainSec.toString().padLeft(2, '0') +
            ')'));
  }

  Widget buildDataTransfer(BuildContext context) {
    return AlertDialog(
        title: Center(
            child: Text(
          'Daten werden übertragen',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        )),
        content: Center(
            child: DataTransferAnimationWidget(
          Icons.computer_sharp,
          Icons.computer_sharp,
          columns: 15,
          iconSize: 40,
          pdefaultcolor: Theme.of(context).primaryColorLight,
          phighlightColor: Theme.of(context).primaryColor,
        )));
  }

  Widget buildWait() {
    return AlertDialog(
        title: Center(
            child: Text(
          'Bitte gebe eine Banknote in das Lesegerät',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        )),
        content: Center(
            child: WidgetCircularAnimator(
          size: 150,
          child: Container(
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.grey[200]),
            child: Image.asset(
              'assets/img/payinnote.png',
            ),
          ),
        )));
  }

  Widget buildError(BuildContext context, NoteProvider noteProvider) {
    closeTimerActive = true;
    if (noteProvider.lastErrorMsg == 'strimming') {
      return AlertDialog(
          title: Center(
              child: Text(
            'Fehler',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          )),
          content: Column(
            children: [
              Text("Du Schlingel! Anzeige ist raus...",
                  style: TextStyle(fontSize: 20)),
              SizedBox(
                child: Image(image: AssetImage("assets/img/policedoggo.png")),
                height: 170,
              ),
              autocloseBtn(),
            ],
          ));
    } else {
      controller.forward();
      return AlertDialog(
          title: Center(
              child: Text(
            'Fehler',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          )),
          content: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  StatefulBuilder(builder: (context, setState) {
                    return Center(
                        child: AnimatedBuilder(
                      animation: ani,
                      builder: (context, child) {
                        return Transform(
                          alignment: FractionalOffset.center,
                          transform: Matrix4.rotationZ(ani.value * 6.28319),
                          child: Icon(
                            Icons.error,
                            size: 60,
                            color:
                                Color.lerp(Colors.grey, Colors.red, ani.value),
                          ),
                        );
                      },
                    ));
                  }),
                ],
              ),
              Text(noteProvider
                  .translateErrorMessage(noteProvider.lastErrorMsg)),
              autocloseBtn(),
            ],
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteProvider>(
      builder: (context, noteprovider, _) {
        lastState = noteprovider.state;

        switch (noteprovider.state) {
          case NoteProviderState.WaitForBankNote:
            return buildWait();
          case NoteProviderState.DataExchangeS1:
            return buildDataTransfer(context);
          case NoteProviderState.Error:
            return buildError(context, noteprovider);
          case NoteProviderState.Success:
            {
              autoclose = 0;
              closeTimerActive = true;
              return AlertDialog(
                content: Center(child: Text("OK - Bitte warten")),
              );
            }
          default:
            return Text('x');
        }
      },
    );
  }
}
