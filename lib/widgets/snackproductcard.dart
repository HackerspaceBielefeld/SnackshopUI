import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacebisnackshop/models/snackproduct.dart';
import 'package:spacebisnackshop/providers/cartprovider.dart';
import 'package:spacebisnackshop/providers/displaysizeprovider.dart';

typedef void snackProductSelectedFunc(SnackProduct sp);

class SnackProductCard extends StatelessWidget {
  final SnackProduct snackProduct;
  final snackProductSelectedFunc? onSelected;

  SnackProductCard(this.snackProduct, this.onSelected);

  @override
  Widget build(BuildContext context) {
    DisplaySizeProvider dsprovider = Provider.of<DisplaySizeProvider>(context);

    return DefaultTextStyle(
      style: TextStyle(
        fontSize: dsprovider.sizes!['snackGridTextHeadSize'],
      ),
      child: Card(
        child: InkWell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              foregroundDecoration:
                  snackProduct.disabled || snackProduct.soldout
                      ? BoxDecoration(
                          color: Colors.grey[100],
                          backgroundBlendMode: BlendMode.saturation,
                        )
                      : null,
              child: Column(
                children: [
                  Text(
                    snackProduct.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: dsprovider.sizes!['snackGridTextHeadSize'],
                    ),
                    softWrap: true,
                  ),
                  Text(
                    snackProduct.price.toStringAsFixed(2) +
                        " " +
                        snackProduct.currency,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: dsprovider.sizes!['snackGridTextHeadSize'],
                    ),
                  ),
                  Image.network(
                    snackProduct.imageurl,
                    fit: BoxFit.fitWidth,
                    //width: 64,
                    height: dsprovider.sizes!['snackGridImageHeight'],
                  ),
                ],
              ),
            ),
          ),
          onTap: () {
            if (onSelected != null) {
              onSelected!(snackProduct);
            }
          },
        ),
      ),
    );
  }
}
