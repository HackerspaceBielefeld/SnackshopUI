import 'package:spacebisnackshop/models/snackproduct.dart';

class CartItem {
  final SnackProduct _snackProduct;
  int _amount;

  SnackProduct get snackProduct => _snackProduct;
  int get amount => _amount;

  double get price => _snackProduct.price * amount;

  void incr(int amount) {
    if (amount + _amount > 99) {
      _amount = 99;
    } else {
      _amount += amount;
    }
  }

  void decr(int amount) {
    if (_amount - amount < 0) {
      _amount = 0;
    } else {
      _amount -= amount;
    }
  }

  CartItem({required SnackProduct snackProduct, required int amount})
      : _snackProduct = snackProduct,
        _amount = amount;
}
