import 'package:flutter/material.dart';

class UI with ChangeNotifier {
  int _index = 0;
  set index(newValue) {
    _index = newValue;
    notifyListeners();
  }

  int get index => _index;
}
