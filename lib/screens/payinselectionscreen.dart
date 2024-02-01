import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:spacebisnackshop/screens/payindonationscreen.dart';

import 'payinmembershipfeescreen.dart';
import 'payinsnackshopscreen.dart';

import '../constants.dart' as constants;

class PayInSelectionScreen extends StatelessWidget {
  Widget payInCard(
      IconData icon, String text, bool enabled, void Function() tap) {
    return Card(
      child: InkWell(
        onTap: enabled ? tap : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            enabled
                ? Icon(
                    icon,
                    size: 30,
                  )
                : Stack(
                    children: [
                      Icon(
                        icon,
                        color: Colors.grey,
                        size: 30,
                      ),
                      Icon(MdiIcons.close, color: Colors.redAccent, size: 30),
                    ],
                  ),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18, color: enabled ? Colors.black : Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Einzahlen'),
      ),
      body: Center(
        child: GridView.count(
          crossAxisCount: 3,
          childAspectRatio: 2 / 1,
          children: [
            payInCard(MdiIcons.ticket, 'Code einlösen',
                constants.payInConfig['redeemvoucher'] ?? false, () {
              Navigator.pushReplacementNamed(context, '/redeemvoucher');
            }),
            payInCard(MdiIcons.food, 'Snackkonto aufladen (Bar)', true, () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          PayInSnackshopScreen()));
            }),
            payInCard(MdiIcons.creditCard, 'Snackkonto aufladen (SEPA)',
                constants.payInConfig['payinsepa'] ?? false, () {}),
            payInCard(MdiIcons.scriptTextOutline, 'Mitgliedsbeitrag bezahlen',
                constants.payInConfig['payinmembershipfee'] ?? false, () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          PayInMembershipfeeScreen()));
            }),
            payInCard(MdiIcons.gift, 'Spenden',
                constants.payInConfig['donation'] ?? false, () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          PayInDonationScreen()));
            }),
          ],
        ),
      ),
    );
  }
}
