import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacebisnackshop/animations/spaceLoadingIndicator.dart';
import 'package:spacebisnackshop/models/snackproduct.dart';
import 'package:spacebisnackshop/providers/displaysizeprovider.dart';
import 'package:spacebisnackshop/providers/snackprovider.dart';
import 'package:spacebisnackshop/widgets/snackproductcard.dart';

class SnackproductGrid extends StatelessWidget {
  final snackProductSelectedFunc onSelected;

  const SnackproductGrid(this.onSelected);

  @override
  Widget build(BuildContext context) {
    SnackProvider snackprovider =
        Provider.of<SnackProvider>(context, listen: true);

    DisplaySizeProvider dsprovider = Provider.of<DisplaySizeProvider>(context);

    if (snackprovider.requestRunning) {
      return Center(child: SpaceLoadingIndicator());
    }

    List<SnackProduct> snackProducts = snackprovider.products;
    snackProducts.sort((l, r) => r.sortweight.compareTo(l.sortweight));

    return Scrollbar(
      isAlwaysShown: false,
      child: GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent:
                  dsprovider.sizes!['snackGridMaxCrossAxisExtent'] ?? 1,
              childAspectRatio: 2 / 2,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2),
          itemCount: snackprovider.count,
          itemBuilder: (ctx, index) {
            return SnackProductCard(snackProducts[index], onSelected);
          }),
    );
  }
}
