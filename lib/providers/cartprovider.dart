import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:spacebisnackshop/models/cartitem.dart';
import 'package:spacebisnackshop/models/snackproduct.dart';

class CartProvider extends ChangeNotifier {
  List<CartItem> _products = [];

  final String endpoint;
  final String apiKey;

  int get count => _products.length;
  List<CartItem> get products => [..._products];

  CartProvider({required this.endpoint, required this.apiKey});

  int _productIndex(SnackProduct product) {
    return _products.indexWhere(
        (element) => element.snackProduct.productid == product.productid);
  }

  double cartPrice() {
    double result = 0;
    _products.forEach((element) {
      result += element.price;
    });
    return result;
  }

  bool isInCart(SnackProduct product) {
    return _productIndex(product) >= 0;
  }

  void incrAmount(SnackProduct product, int amount) {
    int idx = _productIndex(product);
    if (idx < 0) {
      addToCart(product, amount);
    } else {
      _products[idx].incr(amount);
    }

    notifyListeners();
  }

  void decrAmount(SnackProduct product, int amount) {
    int idx = _productIndex(product);
    if (idx >= 0) {
      _products[idx].decr(amount);

      if (_products[idx].amount == 0) {
        _products.removeAt(idx);
      }

      notifyListeners();
    }
  }

  void addToCart(SnackProduct product, int amount) {
    if (isInCart(product)) {
      incrAmount(product, 1);
    } else {
      _products.add(CartItem(snackProduct: product, amount: amount));

      notifyListeners();
    }
  }

  void removeAll() {
    _products.clear();
    notifyListeners();
  }

  void remove(SnackProduct product) {
    int idx = _productIndex(product);
    if (idx >= 0) {
      _products.removeAt(idx);
      notifyListeners();
    }
  }
}
