import 'package:flutter/material.dart';

final progressErrors = {
  -1: '文件选择错误：未选中任何文件',
};

class Progressprov with ChangeNotifier {
  double _progress = 0;

  double get progress => _progress;

  bool get success => _progress == 1;
  bool get onError => _progress < 0;

  String get errorString => progressErrors[_progress]!;

  void update(double v) {
    _progress = v;
    notifyListeners();
  }

  void reset() {
    _progress = 0;
    notifyListeners();
  }
}
