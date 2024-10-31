import 'package:colorify/backend/abstracts/rgbmapping.dart';
import 'package:flutter/foundation.dart';

enum GenerateMode {
  match,
  dust,
}

class Particleprov with ChangeNotifier {
  /// AVC: Arguments Validity Check
  final Map<String, bool> _avcmap = {
    'resize': true,
    'height': true,
    'rotate': true,
  };
  bool avcWhere(String key) {
    return _avcmap[key]!;
  }

  bool get avc => _avcmap.values.every((e) => e);
  void updateAVC(String key, bool v) {
    _avcmap[key] = v;
    notifyListeners();
  }

  int _plane = 0;
  int _interpolation = 0;
  GenerateMode _mode = GenerateMode.match;
  List<RGBMapping> _mappings = [RGBMapping(r: 0, g: 0, b: 0, id: 'colorify:endrod')];

  int get plane => _plane;
  int get interpolation => _interpolation;
  GenerateMode get mode => _mode;
  List<RGBMapping> get mappings => _mappings;

  set interpolation(int v) {
    _interpolation = v;
    notifyListeners();
  }

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
}
