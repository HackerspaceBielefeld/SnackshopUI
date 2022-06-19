import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacebisnackshop/models/snackproduct.dart';
import 'package:spacebisnackshop/providers/cartprovider.dart';
import 'package:spacebisnackshop/widgets/snackproductcard.dart';
import 'package:spacebisnackshop/widgets/snackproductgrid.dart';

class AssignEANScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Provider.of<CartProvider>(context, listen: false).removeAll();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('EAN Zuweisung'),
        ),
        body: SnackproductGrid((SnackProduct snackProduct) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: SnackProductCard(snackProduct, null),
                );
              });

          //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(snackProduct.name)));
        }),
      ),
    );
  }
}
