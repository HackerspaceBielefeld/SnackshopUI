import 'dart:io';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:spacebisnackshop/animations/carlsjr.dart';
import 'package:spacebisnackshop/models/snackproduct.dart';
import 'package:spacebisnackshop/providers/displaysizeprovider.dart';
import 'package:spacebisnackshop/providers/nfcprovider.dart';
import 'package:spacebisnackshop/providers/noteprovider.dart';
import 'package:spacebisnackshop/screens/assigneanscreen.dart';
import 'package:spacebisnackshop/screens/maintainancescreen.dart';
import 'package:spacebisnackshop/screens/payinselectionscreen.dart';
import 'package:spacebisnackshop/screens/redeemvoucherscreen.dart';
import 'package:spacebisnackshop/screens/servicetoolsscreen.dart';

import 'package:spacebisnackshop/widgets/cartwidget.dart';
import 'package:spacebisnackshop/widgets/datatransferanimationwidget.dart';
import 'package:spacebisnackshop/widgets/snackproductcard.dart';
import 'package:spacebisnackshop/widgets/snackproductgrid.dart';

import 'constants.dart' as constants;

import 'dialogs/nfccommdialog.dart';
import 'providers/cartprovider.dart';
import 'providers/snackprovider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<DisplaySizeProvider>(
        create: (_) => DisplaySizeProvider()),
    ChangeNotifierProvider<CartProvider>(
        create: (_) => CartProvider(
            endpoint: constants.endpoint, apiKey: constants.apikey)),
    ChangeNotifierProvider<SnackProvider>(
        create: (_) => SnackProvider(
            endpoint: constants.endpoint, apiKey: constants.apikey)),
    ChangeNotifierProvider<NFCProvider>(create: (_) => NFCProvider()),
    ChangeNotifierProvider<NoteProvider>(create: (_) => NoteProvider()),
  ], child: SpacebiSnackshopApp()));
}

class SpacebiSnackshopApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _SpacebiSnackshopAppState createState() => _SpacebiSnackshopAppState();
}

class _SpacebiSnackshopAppState extends State<SpacebiSnackshopApp> {
  @override
  void initState() {
    super.initState();
    context.read<SnackProvider>().fetchProducts(false);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Space.bi Snackshop',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        textTheme: TextTheme(
          caption: TextStyle(fontSize: 8.0),
          //title: TextStyle(fontSize: 8.0),
          //subtitle: TextStyle(fontSize: 8.0),
          //body1: TextStyle(fontSize: 8.0),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: SpacebiSnackshopMainScreen(),
      routes: {
        '/redeemvoucher': (context) => RedeemVoucherScreen(),
        '/screensafer': (context) => CarlsScreensafer(),
        '/maintainance': (context) => MaintainanceScreensafer(),
        '/payinselection': (context) => PayInSelectionScreen(),
        '/serviceTools': (context) => ServiceToolsScreen(),
        '/assignEAN': (context) => AssignEANScreen(),
      },
      initialRoute: '/maintainance',
    );
  }
}

class SpacebiSnackshopMainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(30.0),
        child: AppBar(
          title: Text('Space.bi Snackshop'),
          actions: [
            /*
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/electricsocket');
                },
                child: Icon(MdiIcons.powerSocketDe)),
              */
            ElevatedButton(onPressed: () {
              Provider.of<DisplaySizeProvider>(context, listen: false)
                  .changeToNextSize();
            }, child: Consumer<DisplaySizeProvider>(
              builder: (context, dsprovider, child) {
                switch (dsprovider.current) {
                  case DisplaySize.Small:
                    return Text('S');
                  case DisplaySize.Medium:
                    return Text('M');
                  case DisplaySize.Large:
                    return Text('L');
                  case DisplaySize.XLarge:
                    return Text('XL');
                  default:
                    return Text('?');
                }
              },
            )),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/payinselection');
                },
                child: Text('Einzahlen')),
            ElevatedButton(
                onPressed: () async {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        Provider.of<NFCProvider>(context, listen: false)
                            .fetchTransactions();
                        return NFCCommDialog();
                      }).then((value) {
                    NFCProviderState state = value;
                    if (state == NFCProviderState.Success) {
                    } else {}
                  });
                },
                child: Text('Mein Konto')),
            ElevatedButton(
                onPressed: () {
                  Provider.of<SnackProvider>(context, listen: false)
                      .fetchProducts(false);
                },
                child: Icon(Icons.refresh)),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Row(
          children: [
            Expanded(
                flex: 2,
                child: Container(
                  child: SnackproductGrid((SnackProduct snackProduct) {
                    Provider.of<CartProvider>(context, listen: false)
                        .addToCart(snackProduct, 1);
                  }),
                )),
            VerticalDivider(),
            Expanded(flex: 1, child: CartWidget())
          ],
        ),
      ),
    );
  }
}
