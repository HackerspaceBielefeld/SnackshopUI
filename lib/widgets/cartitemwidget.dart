import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacebisnackshop/models/cartitem.dart';
import 'package:spacebisnackshop/providers/cartprovider.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartitem;

  CartItemWidget(this.cartitem);

  @override
  Widget build(BuildContext context) {
    CartProvider cartprovider =
        Provider.of<CartProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 1, child: Text(cartitem.amount.toString() + 'x')),
          Expanded(
            flex: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cartitem.snackProduct.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 8),
                ),
                Text(cartitem.snackProduct.price.toStringAsFixed(2) + ' SC',
                    style: TextStyle(fontSize: 8))
              ],
            ),
          ),
          Expanded(
              flex: 2,
              child: Text(cartitem.price.toStringAsFixed(2) + ' SC',
                  style: TextStyle(fontSize: 8))),
          Row(
            children: [
              InkWell(
                child: Card(
                  child: Icon(
                    Icons.plus_one,
                    size: 11,
                  ),
                ),
                onTap: () => cartprovider.incrAmount(cartitem.snackProduct, 1),
              ),
              InkWell(
                child: Card(
                  child: Icon(
                    Icons.exposure_minus_1,
                    size: 11,
                  ),
                ),
                onTap: () => cartprovider.decrAmount(cartitem.snackProduct, 1),
              ),
              InkWell(
                child: Card(
                  child: Icon(
                    Icons.delete,
                    size: 11,
                  ),
                ),
                onTap: () => cartprovider.remove(cartitem.snackProduct),
              ),
            ],
          )
        ],
      ),
    );
  }
}
