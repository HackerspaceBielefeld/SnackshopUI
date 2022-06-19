class SnackProduct {
  final int productid;
  final String name;
  final bool disabled;
  final bool soldout;
  final String imageurl;
  final double price;
  final String currency;
  final int sortweight;

  SnackProduct(
      {required this.productid,
      required this.name,
      required this.disabled,
      required this.soldout,
      required this.imageurl,
      required this.price,
      required this.currency,
      required this.sortweight});

  SnackProduct.fromJson(Map json)
      : this.productid = json['id'],
        this.name = json['name'],
        this.disabled = json['disabled'] == 1,
        this.soldout = json['soldout'] == 1,
        this.imageurl = 'http://space.bi/snackimg/' + json['imageurl'],
        this.price = (json['prices'] as List<dynamic>)
            .firstWhere((element) => element["currency"] == "SC")["price"]
            .toDouble(),
        this.currency = "SC",
        this.sortweight = json['sortweight'];
}
