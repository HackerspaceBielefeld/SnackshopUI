import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:spacebisnackshop/models/cartitem.dart';

enum NFCProviderState { WaitForTag, DataExchange, Error, Success }
enum NFCBinary { Transactionreader, Exectransaction, FinanceTokenReader }

const Map<String, String> basepath = {
  'linux': '/opt/spacenfc',
  'windows': 'C:\\Users\\bjoern\\Desktop\\mftest'
};

const Map<String, String> errorMessages = {
  'unsupported': 'NFC Tag wird nicht unterstützt ',
  'noapp': 'Space.bi App fehlt auf den Token',
  'connfailed': 'Serververbindung fehlgeschlagen',
  'noprice': 'Preisfehler',
  'readerror': 'Tag Lesefehler',
  'timeout': 'Zeitüberschreitung',
  'not_found': 'Daten nicht gefunden',
  'invalid_cart': 'Ungültiger Warenkorb',
  'account_locked': 'Konto ist gesperrt',
  'account_invalid': 'Konto ist ungültig',
  'low_credit': 'Zu wenig Guthaben',
  'price_missmatch': 'Preis unterscheidet sich vom Server',
  'internalerror': 'Systemfehler',
  'internal_error': 'Datenbankfehler',
};

class NFCProvider extends ChangeNotifier {
  NFCProviderState state = NFCProviderState.WaitForTag;
  String lastErrorMsg = "";

  List<String> _jsonBuff = [];
  bool _jsonRead = false;
  Map<String, dynamic>? jsonAnswer;
  NFCBinary? lastExec;

  String _binName(NFCBinary bin) {
    switch (bin) {
      case NFCBinary.Transactionreader:
        return "transactionreader";
      case NFCBinary.Exectransaction:
        return "exectransaction";
      case NFCBinary.FinanceTokenReader:
        return "financetokenreader";
    }
    return "";
  }

  String translateErrorMessage(String msg) {
    if (errorMessages.containsKey(msg)) {
      return errorMessages[msg]!;
    }
    return msg;
  }

  String _executable(NFCBinary bin) {
    print(Platform.operatingSystem);
    switch (Platform.operatingSystem) {
      case 'windows':
        {
          return basepath['windows']! + '\\' + _binName(bin) + '.exe';
        }
      case 'linux':
        {
          return basepath['linux']! + '/build/' + _binName(bin);
        }
      default:
        {
          throw Exception('not supported platform');
        }
    }
  }

  void parseLine(String multiline) {
    multiline.split("\n").forEach((line) {
      switch (line.trim()) {
        case "----TAG PRESENT----":
          {
            state = NFCProviderState.DataExchange;
            notifyListeners();
            break;
          }
        case "----BEGIN JSON----":
          {
            _jsonRead = true;
            _jsonBuff.clear();
            break;
          }
        case "----END JSON----":
          {
            _jsonRead = false;

            Map<String, dynamic> decodedanswer =
                jsonDecode(_jsonBuff.join("\n"));
            //print(decodedanswer);
            jsonAnswer = decodedanswer;
            if (jsonAnswer != null) {
              if (jsonAnswer!.containsKey("error")) {
                if (jsonAnswer!['error'] == "") {
                  state = NFCProviderState.Success;
                } else {
                  lastErrorMsg = jsonAnswer!["error"];
                  state = NFCProviderState.Error;
                }
              } else {
                state = NFCProviderState.Error;
              }
            } else {
              state = NFCProviderState.Error;
            }

            notifyListeners();
            break;
          }
        default:
          {
            if (_jsonRead) {
              _jsonBuff.add(line);
            }
          }
      }
    });
  }

  Future<void> waitForBuild() async {
    return Future.delayed(Duration(seconds: 1));
  }

  Future<void> redeem(String code) async {
    //await waitForBuild();
    lastExec = NFCBinary.Exectransaction;

    state = NFCProviderState.WaitForTag;
    //notifyListeners();

    var proc = await Process.start(
        _executable(NFCBinary.Exectransaction),
        [
          '-k',
          basepath['linux']! + '/conf/desfirekeys.ini',
          '-c',
          basepath['linux']! + '/conf/localconfig.ini',
          '--redeem',
          code,
        ],
        mode: ProcessStartMode.detachedWithStdio);

    proc.stderr.listen((event) {
      String out = String.fromCharCodes(event);

      print("stderr: " + out);
    });

    proc.stdout.listen((event) {
      String out = String.fromCharCodes(event);

      print('"' + out + '"');
      parseLine(out);
    }, onDone: () {
      print("ondone");
    }, onError: (error) {
      print("onerror " + error.toString());
    }, cancelOnError: false);
  }

  Future<void> buy(List<CartItem> products, double price) async {
    //await waitForBuild();
    lastExec = NFCBinary.Exectransaction;

    state = NFCProviderState.WaitForTag;

    List<String> productParams = [];
    products.forEach((product) {
      productParams.add(product.snackProduct.productid.toString() +
          ":" +
          product.amount.toString());
    });

    //notifyListeners();

    List<String> params = [
          '-k',
          basepath['linux']! + '/conf/desfirekeys.ini',
          '-c',
          basepath['linux']! + '/conf/localconfig.ini',
          '--cart'
        ] +
        productParams +
        [
          '--price',
          price.toString(),
        ];

    var proc = await Process.start(
        _executable(NFCBinary.Exectransaction), params,
        runInShell: false, mode: ProcessStartMode.detachedWithStdio);

    proc.stderr.listen((event) {
      String out = String.fromCharCodes(event);

      print("stderr: " + out);
    });

    proc.stdout.listen((event) {
      String out = String.fromCharCodes(event);

      print('"' + out + '"');
      parseLine(out);
    });
  }

  Future<void> fetchTransactions() async {
    //await waitForBuild();

    lastExec = NFCBinary.Transactionreader;
    state = NFCProviderState.WaitForTag;
    //notifyListeners();

    List<String> params = [
      '-k',
      basepath['linux']! + '/conf/desfirekeys.ini',
      '-c',
      basepath['linux']! + '/conf/localconfig.ini',
    ];

    var proc = await Process.start(
        _executable(NFCBinary.Transactionreader), params,
        runInShell: false, mode: ProcessStartMode.detachedWithStdio);

    proc.stderr.listen((event) {
      String out = String.fromCharCodes(event);

      print("stderr: " + out);
    });

    proc.stdout.listen((event) {
      String out = String.fromCharCodes(event);

      print('"' + out + '"');
      parseLine(out);
    });
  }

  Future<void> readFinancetoken() async {
    //await waitForBuild();

    lastExec = NFCBinary.FinanceTokenReader;
    state = NFCProviderState.WaitForTag;
    //notifyListeners();

    List<String> params = [
      '-k',
      basepath['linux']! + '/conf/desfirekeys.ini',
      '-c',
      basepath['linux']! + '/conf/localconfig.ini',
    ];

    var proc = await Process.start(
        _executable(NFCBinary.FinanceTokenReader), params,
        runInShell: false, mode: ProcessStartMode.detachedWithStdio);

    proc.stderr.listen((event) {
      String out = String.fromCharCodes(event);

      print("stderr: " + out);
    });

    proc.stdout.listen((event) {
      String out = String.fromCharCodes(event);

      print('"' + out + '"');
      parseLine(out);
    });
  }
}
