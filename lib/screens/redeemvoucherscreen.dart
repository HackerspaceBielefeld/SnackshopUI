import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacebisnackshop/dialogs/nfccommdialog.dart';
import 'package:spacebisnackshop/providers/nfcprovider.dart';
import 'package:spacebisnackshop/widgets/datatransferanimationwidget.dart';
import 'package:spacebisnackshop/widgets/keypad.dart';
import 'package:animate_icons/animate_icons.dart';
import 'package:widget_circular_animator/widget_circular_animator.dart';

class RedeemVoucherScreen extends StatefulWidget {
  @override
  _RedeemVoucherScreenState createState() => _RedeemVoucherScreenState();
}

const int maxcodelen = 8;

class _RedeemVoucherScreenState extends State<RedeemVoucherScreen> {
  List<String> code = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String strcode = "";

    while (code.length > maxcodelen) {
      code.removeAt(0);
    }

    for (int i = 0; i < code.length; i++) {
      strcode += code[i] + ' ';
    }

    for (int i = code.length; i < maxcodelen; i++) {
      strcode += '_ ';
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(
          title: Text('Voucher einlösen'),
        ),
      ),
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'Bitte gebe deinen Vouchercode ein und drücke auf "Aufladen". Anschließend kannst du dein Desfire® Token an die Lesefläche halten.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      Text(strcode,
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                code.clear();
                              });
                            },
                            child: Text('Löschen'),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red, // background
                              onPrimary: Colors.white, // foreground
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (code.length < 8) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Code ist nicht vollständig')));
                                return;
                              }

                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    Provider.of<NFCProvider>(context,
                                            listen: false)
                                        .redeem(code.join(''));
                                    return NFCCommDialog();
                                  }).then((value) {
                                NFCProviderState state = value;
                                if (state == NFCProviderState.Success) {
                                  Navigator.pop(context);
                                } else {}
                              });
                            },
                            child: Text('Aufladen'),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green, // background
                              onPrimary: Colors.white, // foreground
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )),
            VerticalDivider(),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text('Eingabefeld',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  KeypadWidget((key) {
                    setState(() {
                      code.add(key);
                    });
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
