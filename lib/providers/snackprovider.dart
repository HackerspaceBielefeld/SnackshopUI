import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:spacebisnackshop/models/snackproduct.dart';

class SnackProvider extends ChangeNotifier {
  final String endpoint;
  final String apiKey;
  List<SnackProduct> _products = [];

  bool _requestRunning = false;

  int get count => _products.length;
  bool get requestRunning => _requestRunning;

  List<SnackProduct> get products => [..._products];

  SnackProvider({required this.endpoint, required this.apiKey});

  Future<void> fetchProducts(bool withdisabled) async {
    _requestRunning = true;
    //notifyListeners();
    //await Future.delayed(Duration(seconds: 2));

    final response = await http.get(
      Uri.parse(endpoint + 'products' + (withdisabled ? '?withdisabled' : '')),
      headers: {'X-Api-Key': apiKey},
    );

    //print(response.statusCode);
    //print(response.body);
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      _products.clear();
      data.forEach((element) {
        _products.add(SnackProduct.fromJson(element));
      });

      _requestRunning = false;
      notifyListeners();
    } else {
      print("response not 200");
      _requestRunning = false;
      notifyListeners();
    }
  }
}
