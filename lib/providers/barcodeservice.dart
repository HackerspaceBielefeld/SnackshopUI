import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:spacebisnackshop/models/snackproduct.dart';

enum BarcodeServiceReceiverType { cart, barcodeAssign }

typedef BarcodeServiceReceiverFunc(String barcode);

class BarcodeService {
  BarcodeServiceReceiverType? _currentReceiver;
  Map<BarcodeServiceReceiverType, BarcodeServiceReceiverFunc> _receivers = {};

  final String endpoint;
  final String apiKey;

  BarcodeServiceReceiverType? get currentReceiver => _currentReceiver;

  BarcodeService({required this.endpoint, required this.apiKey}) {
    RawDatagramSocket.bind('0.0.0.0', 8182).then((RawDatagramSocket udpSocket) {
      udpSocket.listen((e) {
        Datagram? dg = udpSocket.receive();
        String barcode = '';
        if (dg != null) {
          dg.data.forEach((element) {
            if ((element >= 0x30) && (element <= 0x7a)) {
              barcode += String.fromCharCode(element);
            }
          });
          //print("received barcode '" + barcode + "'");
          if (barcode.length > 3) {
            if (_currentReceiver != null) {
              if (_receivers.containsKey(_currentReceiver)) {
                _receivers[_currentReceiver]!(barcode);
              }
            }
          }
        }
      });
    });
  }

  defineReceiver(BarcodeServiceReceiverType type, BarcodeServiceReceiverFunc func) {
    _receivers[type] = func;
  }

  setReceiver(BarcodeServiceReceiverType? type) {
    _currentReceiver = type;
  }

  Future<void> deleteBarcode(int id, String barcode) async {
    final response = await http.delete(
      Uri.parse(endpoint + 'products/' + id.toString() + '/ean/' + barcode),
      headers: {'X-Api-Key': apiKey},
    );
  }

  Future<void> addBarcode(int id, String barcode) async {
    final response = await http.post(Uri.parse(endpoint + 'products/' + id.toString() + '/ean/'),
        headers: {'X-Api-Key': apiKey}, body: {barcode: barcode});
  }

  Future<List<String>?> fetchEANSByProductId(int id) async {
    final response = await http.get(
      Uri.parse(endpoint + 'products/' + id.toString() + '/ean'),
      headers: {'X-Api-Key': apiKey},
    );

    print(response.body);
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      //return data.map((e) => e.toString()).toList();
      return data.cast<String>();
    } else {
      return null;
    }
  }

  Future<SnackProduct?> fetchProductByEAN(String ean) async {
    //print("fetching " + ean);
    final response = await http.get(
      Uri.parse(endpoint + 'products/ean/' + ean),
      headers: {'X-Api-Key': apiKey},
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      if (data.containsKey('id')) {
        SnackProduct snackProduct = SnackProduct.fromJson(data);
        return snackProduct;
      }
      return null;
    } else {
      return null;
    }
  }
}
