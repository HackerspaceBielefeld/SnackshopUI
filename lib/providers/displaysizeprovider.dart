import 'package:flutter/material.dart';

enum DisplaySize { Small, Medium, Large, XLarge }

const Map<DisplaySize, Map<String, double>> _sizes = {
  DisplaySize.Small: {
    'snackGridMaxCrossAxisExtent': 90,
    'snackGridImageHeight': 22,
    'snackGridTextHeadSize': 6,
  },
  DisplaySize.Medium: {
    'snackGridMaxCrossAxisExtent': 120,
    'snackGridImageHeight': 40,
    'snackGridTextHeadSize': 8,
  },
  DisplaySize.Large: {
    'snackGridMaxCrossAxisExtent': 150,
    'snackGridImageHeight': 60,
    'snackGridTextHeadSize': 11,
  },
  DisplaySize.XLarge: {
    'snackGridMaxCrossAxisExtent': 220,
    'snackGridImageHeight': 100,
    'snackGridTextHeadSize': 16,
  },
};

class DisplaySizeProvider extends ChangeNotifier {
  DisplaySize _current = DisplaySize.Medium;
  DisplaySize get current => _current;

  Map<String, double>? get sizes => _sizes[_current];

  void changeSize(DisplaySize size) {
    _current = size;
    notifyListeners();
  }

  void changeToNextSize() {
    switch (_current) {
      case DisplaySize.Small:
        {
          changeSize(DisplaySize.Medium);
          break;
        }
      case DisplaySize.Medium:
        {
          changeSize(DisplaySize.Large);
          break;
        }
      case DisplaySize.Large:
        {
          changeSize(DisplaySize.XLarge);
          break;
        }
      case DisplaySize.XLarge:
        {
          changeSize(DisplaySize.Small);
          break;
        }
    }
  }
}
