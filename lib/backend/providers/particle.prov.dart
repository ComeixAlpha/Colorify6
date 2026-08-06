import 'dart:convert';

import 'package:colorify/backend/abstracts/rgbmapping.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum GenerateMode { match, dust }

class Particleprov with ChangeNotifier {
  static const String _mappingsPrefsKey = 'particle_mappings';

  /// AVC: Arguments Validity Check
  final Map<String, bool> _avcmap = {'resize': true, 'height': true, 'rotate': true};
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
  List<RGBMapping> _mappings = [RGBMapping(r: 0, g: 0, b: 0, id: 'minecraft:endrod')];

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
    _mappings = List.of(v);
    _saveMappings();
    notifyListeners();
  }

  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_mappingsPrefsKey);
      if (raw == null || raw.isEmpty) return;
      final decoded = jsonDecode(raw) as List<dynamic>;
      _mappings = decoded
          .map((e) => RGBMapping.fromJson(e as Map<String, dynamic>))
          .toList();
      notifyListeners();
    } catch (_) {
    }
  }

  Future<void> _saveMappings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _mappingsPrefsKey,
        jsonEncode(_mappings.map((e) => e.toJson()).toList()),
      );
    } catch (_) {
    }
  }
}
