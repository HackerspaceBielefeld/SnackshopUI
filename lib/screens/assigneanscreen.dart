import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacebisnackshop/animations/spaceLoadingIndicator.dart';
import 'package:spacebisnackshop/models/snackproduct.dart';
import 'package:spacebisnackshop/providers/cartprovider.dart';
import 'package:spacebisnackshop/providers/barcodeservice.dart';
import 'package:spacebisnackshop/providers/snackprovider.dart';
import 'package:spacebisnackshop/widgets/snackproductcard.dart';
import 'package:spacebisnackshop/widgets/snackproductgrid.dart';

class AssignEANScreen extends StatelessWidget {
  Widget buildBarcodeListTile(BuildContext context, SnackProduct snackProduct, String barcode, StateSetter setState) {
    return ListTile(
      title: Text(barcode),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          setState(() {
            context.read<BarcodeService>().deleteBarcode(snackProduct.productid, barcode);
          });
        },
      ),
    );
  }

  Widget buildBarcodeAlertDialog(BuildContext context, SnackProduct snackProduct) {
    context.read<BarcodeService>().setReceiver(BarcodeServiceReceiverType.barcodeAssign);

    return AlertDialog(
      content: StatefulBuilder(builder: (context, setState) {
        context.read<BarcodeService>().defineReceiver(BarcodeServiceReceiverType.barcodeAssign, (String barcode) {
          setState(() {
            context.read<BarcodeService>().addBarcode(snackProduct.productid, barcode);
          });
        });

        return Column(
          children: [
            SnackProductCard(snackProduct, null),
            Text('Barcodes:'),
            FutureBuilder(
                future: context.read<BarcodeService>().fetchEANSByProductId(snackProduct.productid),
                builder: (context, AsyncSnapshot<List<String>?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data == null) return Text('Keine Einträge');

                    List<Widget> items = [];
                    for (int i = 0; i < snapshot.data!.length; i++) {
                      items.add(buildBarcodeListTile(context, snackProduct, snapshot.data![i], setState));
                    }
                    return Column(
                      children: items,
                    );
                  } else {
                    return SpaceLoadingIndicator();
                  }
                }),
          ],
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<SnackProvider>(context, listen: false).fetchProducts(true);
    return WillPopScope(
      onWillPop: () async {
        Provider.of<CartProvider>(context, listen: false).removeAll();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Barcode Zuweisung'),
        ),
        body: SnackproductGrid((SnackProduct snackProduct) {
          BarcodeServiceReceiverType? barcodeServiceReceiverType = context.read<BarcodeService>().currentReceiver;

          // Wird ausgeführt, wenn ein Produkt angetippt wird
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return buildBarcodeAlertDialog(context, snackProduct);
              }).then((value) {
            // Dialog zu - also BarcodeReceiver auf alten nwert zurück
            context.read<BarcodeService>().setReceiver(barcodeServiceReceiverType);
          });
        }),
      ),
    );
  }
}
