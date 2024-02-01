import 'dart:async';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

import 'package:animate_icons/animate_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacebisnackshop/models/transaction.dart';
import 'package:spacebisnackshop/providers/nfcprovider.dart';
import 'package:spacebisnackshop/widgets/datatransferanimationwidget.dart';
import 'package:widget_circular_animator/widget_circular_animator.dart';

class NFCCommDialog extends StatefulWidget {
  @override
  _NFCCommDialogState createState() => _NFCCommDialogState();
}

class _NFCCommDialogState extends State<NFCCommDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> ani;

  late Timer closeTimer;

  late Timer troubleTimer;
  bool inTrouble = false;

  bool closeTimerActive = true;
  int autoclose = 30;

  NFCProviderState? lastState;

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
    troubleTimer.cancel();
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

  Widget buildTroubleBox() {
    return AlertDialog(
        title: Center(
            child: Text(
          'Hobbala',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        )),
        content: Column(
          children: [
            Expanded(child: Image.asset('assets/img/fu.png')),
            ElevatedButton(
                onPressed: () {
                  Process.start('reboot', [],
                      runInShell: false,
                      mode: ProcessStartMode.detachedWithStdio);
                },
                child: Text('Reboot System'))
          ],
        ));
  }

  Widget buildWait() {
    if (inTrouble) {
      return buildTroubleBox();
    }

    troubleTimer = Timer(Duration(seconds: 20), () {
      setState(() {
        inTrouble = true;
      });
    });

    return AlertDialog(
        title: Center(
            child: Text(
          'Bitte halte dein Tag an das Lesegerät und warte bis zur Bestätigung',
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
              'assets/img/nfccard.png',
            ),
          ),
        )));
  }

  Widget buildDataTransfer(BuildContext context) {
    if (inTrouble) {
      return buildTroubleBox();
    }

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

  Widget buildError(BuildContext context, NFCProvider nfcProvider) {
    closeTimerActive = true;
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
                          color: Color.lerp(Colors.grey, Colors.red, ani.value),
                        ),
                      );
                    },
                  ));
                }),
              ],
            ),
            Text(nfcProvider.translateErrorMessage(nfcProvider.lastErrorMsg)),
            autocloseBtn(),
          ],
        ));
  }

  Widget buildSuccessCredit(BuildContext context, NFCProvider nfcProvider) {
    closeTimerActive = true;
    controller.forward();
    return AlertDialog(
        title: Center(
            child: Text(
          'Abgeschlossen',
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
                          Icons.check_circle,
                          size: 50 + (ani.value * 10),
                          color:
                              Color.lerp(Colors.grey, Colors.green, ani.value),
                        ),
                      );
                    },
                  ));
                }),
              ],
            ),
            Builder(builder: (context) {
              List<TableRow> rows = [];
              if (nfcProvider.jsonAnswer!.containsKey("oldBalance")) {
                rows.add(TableRow(children: [
                  Text("Alter Kontostand"),
                  Text(double.parse(nfcProvider.jsonAnswer!["oldBalance"])
                          .toStringAsFixed(2) +
                      ' SC'),
                ]));
              }

              if (nfcProvider.jsonAnswer!.containsKey("newBalance")) {
                rows.add(TableRow(children: [
                  Text("Neuer Kontostand"),
                  Text(double.parse(nfcProvider.jsonAnswer!["newBalance"])
                          .toStringAsFixed(2) +
                      ' SC'),
                ]));
              }

              return Table(children: rows);
            }),
            autocloseBtn(),
          ],
        ));
  }

  Widget buildSuccessTransactions(
      BuildContext context, NFCProvider nfcProvider) {
    closeTimerActive = true;
    controller.forward();
    return AlertDialog(
        title: Center(
            child: Row(
          children: [
            AnimatedBuilder(
              animation: ani,
              builder: (context, child) {
                return Transform(
                  alignment: FractionalOffset.center,
                  transform: Matrix4.rotationZ(ani.value * 6.28319),
                  child: Icon(
                    Icons.monetization_on_outlined,
                    size: 30 + (ani.value * 5),
                    color: Color.lerp(Colors.grey, Colors.green, ani.value),
                  ),
                );
              },
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Deine Buchungen',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        )),
        content: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Builder(builder: (context) {
                  SnackshopTransactionList tl =
                      SnackshopTransactionList.fromJSON(
                          nfcProvider.jsonAnswer!['transactions']);

                  List<DataRow> rows = [];
                  tl.items.forEach((transaction) {
                    rows.add(DataRow(cells: [
                      DataCell(Text(DateFormat('dd.MM.yyyy kk:mm')
                          .format(transaction.datetime))),
                      DataCell(Text(transaction.usagetext)),
                      DataCell(
                          Text(transaction.amount.toStringAsFixed(2) + ' SC')),
                      DataCell(Text(
                          transaction.newbalance.toStringAsFixed(2) + ' SC')),
                    ]));
                  });

                  return FittedBox(
                    child: DataTable(columns: [
                      DataColumn(label: Text('Datum')),
                      DataColumn(label: Text('Verwendungszweck')),
                      DataColumn(label: Text('Betrag')),
                      DataColumn(label: Text('Saldo'))
                    ], rows: rows),
                  );
                }),
              ),
            ),
            autocloseBtn(),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NFCProvider>(
      builder: (context, nfcprovider, _) {
        lastState = nfcprovider.state;
        switch (nfcprovider.state) {
          case NFCProviderState.WaitForTag:
            return buildWait();
          case NFCProviderState.DataExchange:
            return buildDataTransfer(context);
          case NFCProviderState.Error:
            return buildError(context, nfcprovider);
          case NFCProviderState.Success:
            {
              switch (nfcprovider.lastExec) {
                case null:
                  {
                    return Text("nfcprovider error");
                  }
                case NFCBinary.Exectransaction:
                  {
                    return buildSuccessCredit(context, nfcprovider);
                  }
                case NFCBinary.Transactionreader:
                  {
                    return buildSuccessTransactions(context, nfcprovider);
                  }
                case NFCBinary.FinanceTokenReader:
                  {
                    closeTimerActive = true;
                    autoclose = 0;
                    return AlertDialog(
                      content:
                          Center(child: Text("Token geladen - Bitte warten")),
                    );
                  }
              }

              return Container();
            }
          default:
            return Text('x');
        }
      },
    );
  }
}
