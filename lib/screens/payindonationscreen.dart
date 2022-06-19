import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:spacebisnackshop/dialogs/payinnotedialog.dart';
import 'package:spacebisnackshop/providers/noteprovider.dart';
import 'package:spacebisnackshop/widgets/eur_note.dart';

import 'dart:math';

import 'package:confetti/confetti.dart';

const int confettiSeconds = 10;

class PayInDonationScreen extends StatefulWidget {
  @override
  _PayInDonationScreenState createState() => _PayInDonationScreenState();
}

class _PayInDonationScreenState extends State<PayInDonationScreen> {
  late ConfettiController confettiController;

  @override
  void initState() {
    super.initState();
    confettiController =
        ConfettiController(duration: const Duration(seconds: confettiSeconds));
  }

  @override
  void dispose() {
    confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spenden'),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(MdiIcons.gift, size: 40),
                Column(
                  children: [
                    Text('Danke, dass du spenden möchtest!',
                        style: TextStyle(fontSize: 22)),
                    Text(
                        'Drücke auf den Einzahlen-Knopf und gebe deine Spende dem Automaten.',
                        style: TextStyle(fontSize: 18)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Akzeptiert werden: ',
                            style: TextStyle(fontSize: 16)),
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
                ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            Provider.of<NoteProvider>(context, listen: false)
                                .payinnote(
                                    "donation", NoteProviderpayInType.Donation);
                            return PayInNoteDialog();
                          }).then((value) {
                        NoteProviderState state = value;
                        if (state == NoteProviderState.Success) {
                          confettiController.play();
                          Future.delayed(Duration(seconds: confettiSeconds))
                              .then((value) {
                            Navigator.pop(context);
                          });
                        } else {
                          Navigator.pop(context);
                        }
                      });
                    },
                    icon: Icon(MdiIcons.gift),
                    label: Text('Jetzt Spenden')),
              ],
            ),
          ),
          Center(
            child: ConfettiWidget(
              confettiController: confettiController,
              blastDirectionality: BlastDirectionality
                  .explosive, // don't specify a direction, blast randomly
              shouldLoop:
                  false, // start again as soon as the animation is finished
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple
              ],
            ),
          ),
        ],
      ),
    );
  }
}
