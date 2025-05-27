import 'package:flutter/material.dart';

class Pageprov with ChangeNotifier {
  int _page = 0;

  int get page => _page;

  void update(int v) {
    _page = v;
    notifyListeners();
  }
}
