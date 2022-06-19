import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:spacebisnackshop/dialogs/nfccommdialog.dart';
import 'package:spacebisnackshop/dialogs/payinnotedialog.dart';
import 'package:spacebisnackshop/providers/nfcprovider.dart';
import 'package:spacebisnackshop/providers/noteprovider.dart';
import 'package:spacebisnackshop/widgets/eur_note.dart';

class PayInMembershipfeeScreen extends StatefulWidget {
  @override
  _PayInMembershipfeeScreenState createState() =>
      _PayInMembershipfeeScreenState();
}

class _PayInMembershipfeeScreenState extends State<PayInMembershipfeeScreen> {
  int? payinAmount;
  String? financeToken;

  @override
  void initState() {
    super.initState();

    financeToken = "";
    payinAmount = 0;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mitgliedsbeitrag bezahlen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(MdiIcons.scriptOutline, size: 40),
            Column(
              children: [
                Text('Mitgliedsbeitrag einzahlen.',
                    style: TextStyle(fontSize: 22)),
                Text(
                    'Drücke auf den Einzahlen-Knopf und gebe deinen Beitrag dem Automaten.',
                    style: TextStyle(fontSize: 18)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Akzeptiert werden: ', style: TextStyle(fontSize: 16)),
                    EurNote(5),
                    EurNote(10),
                    EurNote(20),
                    EurNote(50),
                    EurNote(100, enabled: false),
                    EurNote(200, enabled: false),
                    EurNote(500, enabled: false)
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                    onPressed: () {
                      NFCProvider nfcProvider =
                          Provider.of<NFCProvider>(context, listen: false);
                      NoteProvider noteProvider =
                          Provider.of<NoteProvider>(context, listen: false);

                      if (financeToken == "") {
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              nfcProvider.readFinancetoken();
                              return NFCCommDialog();
                            }).then((value) {
                          if (value == NFCProviderState.Success) {
                            setState(() {
                              financeToken = nfcProvider.jsonAnswer!['token'];
                            });
                            if (financeToken != null) {
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    noteProvider.payinnote(financeToken!,
                                        NoteProviderpayInType.MembershipFee);
                                    return PayInNoteDialog();
                                  }).then((value) {
                                if (value == NoteProviderState.Success) {
                                  setState(() {
                                    payinAmount = (payinAmount ?? 0) +
                                        int.parse(noteProvider
                                            .jsonAnswer!['notevalue']);
                                  });
                                }
                              });
                            }
                          }
                        });
                      } else {
                        if (financeToken != null) {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                noteProvider.payinnote(financeToken!,
                                    NoteProviderpayInType.MembershipFee);
                                return PayInNoteDialog();
                              }).then((value) {
                            if (value == NoteProviderState.Success) {
                              setState(() {
                                payinAmount = (payinAmount ?? 0) +
                                    int.parse(
                                        noteProvider.jsonAnswer!['notevalue']);
                              });
                            }
                          });
                        }
                      }
                    },
                    icon: Icon(MdiIcons.script),
                    label: Text((payinAmount ?? 0) <= 0
                        ? "Einzahlen"
                        : "Weiter einzahlen")),
                financeToken == ""
                    ? Text('')
                    : Text(
                        "Token erkannt",
                        style: TextStyle(fontSize: 18),
                      ),
                Text(
                    "Eingezahlt: " +
                        (payinAmount ?? 0).toStringAsFixed(2) +
                        "€",
                    style: TextStyle(fontSize: 18)),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Fertig"))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
