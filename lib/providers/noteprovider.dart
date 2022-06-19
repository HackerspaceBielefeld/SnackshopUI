import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

enum NoteProviderState {
  WaitForBankNote,
  DataExchangeS1,
  DataExchangeS2,
  Success,
  Error,
}
enum NoteProviderpayInType { Snackshop, MembershipFee, Donation }

const Map<String, String> basepath = {
  'linux': '/opt/spacenfc',
  'windows': 'C:\\Users\\bjoern\\Desktop\\mftest'
};

const Map<String, String> errorMessages = {
  'internal_error': "Interner Fehler",
  'device_error': "Gerätefehler",
  'note_check_missmatch': "Validierungsfehler",
  'timeout': "Zeitüberschreitung",
};

const Map<NoteProviderpayInType, String> payInTypeStr = {
  NoteProviderpayInType.Snackshop: 'snackshop',
  NoteProviderpayInType.MembershipFee: 'membershipfee',
  NoteProviderpayInType.Donation: 'donation',
};

class NoteProvider extends ChangeNotifier {
  NoteProviderState state = NoteProviderState.WaitForBankNote;
  String lastErrorMsg = "";

  List<String> _jsonBuff = [];
  bool _jsonRead = false;
  Map<String, dynamic>? jsonAnswer;

  String _binName() {
    return "notereader";
  }

  String translateErrorMessage(String msg) {
    if (errorMessages.containsKey(msg)) {
      return errorMessages[msg]!;
    }
    return msg;
  }

  String _executable() {
    print(Platform.operatingSystem);
    switch (Platform.operatingSystem) {
      case 'windows':
        {
          return basepath['windows']! + '\\' + _binName() + '.exe';
        }
      case 'linux':
        {
          return basepath['linux']! + '/build/' + _binName();
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
        case "----NOTE PRESENT----":
          {
            state = NoteProviderState.DataExchangeS1;
            notifyListeners();
            break;
          }
        case "----DATAEX S1 DONE----":
          {
            state = NoteProviderState.DataExchangeS2;
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
            print(decodedanswer);
            jsonAnswer = decodedanswer;
            if (jsonAnswer != null) {
              if (jsonAnswer!.containsKey("error")) {
                if (jsonAnswer!['error'] == "") {
                  state = NoteProviderState.Success;
                } else {
                  lastErrorMsg = jsonAnswer!["error"];
                  state = NoteProviderState.Error;
                }
              } else {
                state = NoteProviderState.Error;
              }
            } else {
              state = NoteProviderState.Error;
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

  Future<void> payinnote(String token, NoteProviderpayInType payintype) async {
    state = NoteProviderState.WaitForBankNote;
    //notifyListeners();

    var proc = await Process.start(
        _executable(),
        [
          '-c',
          basepath['linux']! + '/conf/localconfig.ini',
          '-t',
          token,
          '-p',
          payInTypeStr[payintype] ?? "invalid",
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
}
