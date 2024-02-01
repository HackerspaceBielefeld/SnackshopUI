import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacebisnackshop/dialogs/nfccommdialog.dart';
import 'package:spacebisnackshop/models/cartitem.dart';
import 'package:spacebisnackshop/models/snackproduct.dart';
import 'package:spacebisnackshop/providers/cartprovider.dart';
import 'package:spacebisnackshop/providers/nfcprovider.dart';

import 'cartitemwidget.dart';

class CartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (_, cartProvider, child) {
        return Column(children: [
          Text(
            'Warenkorb',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          ),
          Expanded(
              //height: 250.0,
              child: Scrollbar(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: cartProvider.count,
              separatorBuilder: (ctx, index) => Divider(),
              itemBuilder: (ctx, index) {
                CartItem ci = cartProvider.products[index];

                return CartItemWidget(ci);
                return ListTile(
                  leading: Text(ci.amount.toString() + 'x'),
                  title: Text(ci.snackProduct.name),
                  subtitle:
                      Text(ci.snackProduct.price.toStringAsFixed(2) + ' SC'),
                  trailing: Text(ci.price.toStringAsFixed(2) + ' SC'),
                );
              },
            ),
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              /*Text(
                'Summe:',
                style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
              ),
              Text(cartProvider.cartPrice().toStringAsFixed(2) + ' SC',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),*/
              SizedBox(
                  width: 100,
                  height: 30,
                  child: ElevatedButton(
                      onLongPress: () {
                        if (cartProvider.products.length == 0) {
                          Navigator.pushNamed(context, '/serviceTools');
                        }
                      },
                      onPressed: () {
                        if (cartProvider.products.length == 0) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Es ist nichts im Warenkorb')));
                          return;
                        }

                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              Provider.of<NFCProvider>(context, listen: false)
                                  .buy(cartProvider.products,
                                      cartProvider.cartPrice());
                              return NFCCommDialog();
                            }).then((value) {
                          NFCProviderState state = value;

                          if (state == NFCProviderState.Success) {
                            cartProvider.removeAll();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Row(
                              children: [
                                CircleAvatar(
                                  radius: 30.0,
                                  backgroundImage:
                                      AssetImage('assets/img/apu.jpg'),
                                  backgroundColor: Colors.transparent,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text('Thank you. Come again!'),
                              ],
                            )));
                          } else {}
                        });
                      },
                      child: Text(
                        cartProvider.cartPrice().toStringAsFixed(2) +
                            ' SC - ' +
                            'Jetzt zahlen',
                        style:
                            TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
                      ))),
              IconButton(
                iconSize: 16,
                onPressed: () => cartProvider.removeAll(),
                icon: Icon(Icons.delete),
              ),
            ],
          )
        ]);
      },
    );
  }
}
