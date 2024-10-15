import 'package:colorify/backend/abstracts/rgbmapping.dart';
import 'package:flutter/foundation.dart';

enum GenerateMode {
  match,
  dust,
}

class Particleprov with ChangeNotifier {
  int _plane = 0;
  GenerateMode _mode = GenerateMode.match;
  List<RGBMapping> _mappings = [RGBMapping(r: 0, g: 0, b: 0, id: 'colorify:endrod')];
  bool _avc = true;

  int get plane => _plane;
  GenerateMode get mode => _mode;
  List<RGBMapping> get mappings => _mappings;
  bool get avc => _avc;

  void setPlane(int v) {
    _plane = v;
    notifyListeners();
  }

  void setMode(GenerateMode v) {
    _mode = v;
    notifyListeners();
  }

  void setMappings(List<RGBMapping> v) {
    _mappings = v;
    notifyListeners();
  }

  void updateAVCState(bool v) {
    _avc = v;
    notifyListeners();
  }
}
