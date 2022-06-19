import 'dart:io';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ServiceToolsScreen extends StatelessWidget {
  Widget serviceToolCard(
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
        title: Text('ServiceTools'),
      ),
      body: Center(
        child: GridView.count(
          crossAxisCount: 3,
          childAspectRatio: 2 / 1,
          children: [
            serviceToolCard(MdiIcons.barcodeScan, 'Artikel EAN zuweisen', true,
                () {
              Navigator.pushReplacementNamed(context, '/assignEAN');
            }),
            serviceToolCard(MdiIcons.restore, 'Reboot', true, () {
              Process.start('reboot', [],
                  runInShell: false, mode: ProcessStartMode.detachedWithStdio);
            })
          ],
        ),
      ),
    );
  }
}
