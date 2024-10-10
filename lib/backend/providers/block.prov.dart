import 'package:colorify/backend/extensions/on_list.dart';
import 'package:colorify/backend/palette/palette.block.dart';
import 'package:colorify/backend/palette/palette.carpet.dart';
import 'package:colorify/backend/palette/palette.map.dart';
import 'package:colorify/frontend/pages/particle/particle_mappings.dart';
import 'package:flutter/material.dart';

class Blockprov with ChangeNotifier {
  bool _avc = true;
  bool get avc => _avc;

  int _plane = 0;
  bool _stairType = false;
  bool _useStruct = false;
  bool _dithering = false;
  bool _noGlasses = false;
  bool _noSands = false;
  bool _carperOnly = false;

  bool _init = false;
  bool _dirty = false;

  int get plane => _plane;
  bool get stairType => _stairType;
  bool get useStruct => _useStruct;
  bool get dithering => _dithering;
  bool get noGlasses => _noGlasses;
  bool get noSands => _noSands;
  bool get carpetOnly => _carperOnly;

  List<RGBMapping> _palette = [];
  List<RGBMapping> get palette => _palette;

  void updateAll({
    required int iplane,
    required bool istairType,
    required bool iuseStruct,
    required bool idithering,
    required bool inoGlasses,
    required bool inoSands,
    required bool icarpetOnly,
  }) {
    if (!_init) {
      _palette = _parseBlockPalette(blockPalette);
      _init = true;
    }
    if ([
      _plane,
      _stairType,
      _useStruct,
      _dithering,
      _noGlasses,
      _noSands,
      _carperOnly,
    ].everyInEnumerate(
      (i, v) =>
          v ==
          [
            iplane,
            istairType,
            iuseStruct,
            idithering,
            inoGlasses,
            inoSands,
            icarpetOnly,
          ][i],
    )) {
      return;
    }
    _plane = iplane;
    _stairType = istairType;
    _useStruct = iuseStruct;
    _dithering = idithering;
    _noGlasses = inoGlasses;
    _noSands = inoSands;
    _carperOnly = icarpetOnly;
    _dirty = true;
  }

  void updateAVCState(bool v) {
    _avc = v;
    notifyListeners();
  }

  List<RGBMapping> _parseBlockPalette(List<Map<String, Object>> v) {
    return v.map(
      (e) {
        final rgbs = e['average'] as List<int>;
        return RGBMapping(
          r: rgbs[0],
          g: rgbs[1],
          b: rgbs[2],
          id: e['id'] as String,
        );
      },
    ).toList();
  }

  List<RGBMapping> _parseCarpetPalette(List<Map<String, Object>> v) => _parseBlockPalette(v);

  List<RGBMapping> _parseMapPalette(List<Map<String, Object>> v) {
    return v.map(
      (e) {
        final rgbs = e['rgb'] as List<int>;
        return RGBMapping(
          r: rgbs[0],
          g: rgbs[1],
          b: rgbs[2],
          id: e['block'] as String,
        );
      },
    ).toList();
  }

  List<RGBMapping> refreshPalette() {
    if (!_dirty) {
      return _palette;
    }

    if (_stairType) {
      _palette = _parseMapPalette(mapPalette);
    } else if (_carperOnly) {
      _palette = _parseCarpetPalette(carpetPalette);
    } else {
      _palette = _parseBlockPalette(blockPalette);
      if (_noGlasses) {
        _palette.removeWhere((e) => e.id.contains('glass'));
      }
      if (_noSands) {
        _palette.removeWhere((e) => e.id.contains('sand'));
        _palette.removeWhere((e) => e.id.contains('powder'));
      }
    }

    _dirty = false;

    return _palette;
  }

  void removeWhichIdIs(String id) {
    _palette.removeWhere((e) => e.id == id);
    notifyListeners();
  }
}
