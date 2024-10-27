import 'package:colorify/frontend/components/processing/progress_indicator.dart';
import 'package:flutter/material.dart';

final progressErrors = {
  -1: '文件选择错误：未选中任何文件',
};

class Progressprov with ChangeNotifier {
  /// 2 means unknown
  double _progress = 0;
  String _progressState = '';

  double get progress => _progress;
  String get progressState => _progressState;

  bool get success => _progress == 1;
  bool get onError => _progress < 0;
  bool get onUnknown => _progress == 2;

  String get errorString => progressErrors[_progress]!;

  void update(ProgressData v) {
    _progress = v.progress;
    _progressState = v.state;
    notifyListeners();
  }

  void reset() {
    _progress = 0;
    notifyListeners();
  }
}
