import 'package:colorify/backend/abstracts/palette_entry.dart';
import 'package:colorify/backend/extensions/on_list.dart';
import 'package:colorify/backend/assets/palette/palette.block.dart';
import 'package:colorify/backend/assets/palette/palette.carpet.dart';
import 'package:colorify/backend/assets/palette/palette.map2.dart';
import 'package:colorify/backend/utils/common/palette_parser.dart';
import 'package:colorify/main.dart';
import 'package:flutter/material.dart';

class Blockprov with ChangeNotifier {
  bool _init = false;

  /// AVC: Arguments Validity Check
  final Map<String, bool> _avcmap = {
    'resize': true,
    'flattening': true,
    'basicOffset': true,
    'staircasegap': true,
    'fscoe': true,
    'wsgap': true,
  };
  bool avcWhere(String key) {
    return _avcmap[key]!;
  }

  bool get avc => _avcmap.values.every((e) => e);
  void updateAVC(String key, bool v) {
    _avcmap[key] = v;
    notifyListeners();
  }

  /// Arguments
  int _plane = 0;
  int _rgb = 0;
  int _interpolation = 0;
  bool _stairType = false;
  bool _useStruct = false;
  bool _dithering = false;
  bool _noGlasses = false;
  bool _noSands = false;
  bool _carperOnly = false;

  int get plane => _plane;
  int get rgb => _rgb;
  int get interpolation => _interpolation;
  bool get stairType => _stairType;
  bool get useStruct => _useStruct;
  bool get dithering => _dithering;
  bool get noGlasses => _noGlasses;
  bool get noSands => _noSands;
  bool get carpetOnly => _carperOnly;

  set plane(int v) {
    _plane = v;
    notifyListeners();
  }

  set rgb(int v) {
    _rgb = v;
    notifyListeners();
  }

  set interpolation(int v) {
    _interpolation = v;
    notifyListeners();
  }

  set stairType(bool v) {
    _stairType = v;
    notifyListeners();
  }

  set useStruct(bool v) {
    _useStruct = v;
    notifyListeners();
  }

  set dithering(bool v) {
    _dithering = v;
    notifyListeners();
  }

  set noGlasses(bool v) {
    _noGlasses = v;
    notifyListeners();
  }

  set noSands(bool v) {
    _noSands = v;
    notifyListeners();
  }

  set carpetOnly(bool v) {
    _carperOnly = v;
    notifyListeners();
  }

  List<BlockPaletteEntry> _palette = [];
  List<BlockPaletteEntry> get palette {
    if (!_init) {
      _palette = PaletteParser.block(blockPalette);
      _init = true;
    }
    return _palette;
  }

  List<BlockPaletteEntry> get filteredPalette {
    return palette.where((e) => !_disabled.contains(e.id)).toList();
  }

  List<String> _disabled = [];
  List<String> get disabled => _disabled;

  final List<String> _expandedClasses = [];
  List<String> get expandedClasses => _expandedClasses;

  void refreshPalette() {
    if (_stairType) {
      _palette = PaletteParser.staircase(mapPalette2['data'] as Map<String, String>);
    } else if (_carperOnly) {
      _palette = PaletteParser.carpet(carpetPalette);
    } else {
      _palette = PaletteParser.block(blockPalette);

      if (_noGlasses) {
        _palette.enumerate(
          (i, v) {
            if (v.id.contains('glass')) {
              _disabled.add(v.id);
            }
          },
        );
      } else {
        _disabled.removeWhere((v) => v.contains('glass'));
      }

      if (_noSands) {
        _palette.enumerate(
          (i, v) {
            if (v.id.contains('sand') || v.id.contains('powder')) {
              _disabled.add(v.id);
            }
          },
        );
      } else {
        _disabled.removeWhere((v) => v.contains('glass') || v.contains('powder'));
      }
    }
  }

  void disableWhichIdIs(String id) {
    _disabled.add(id);
    pref!.setStringList('disabled', _disabled);
    notifyListeners();
  }

  void enableWhichIdIs(String id) {
    _disabled.remove(id);
    pref!.setStringList('disabled', _disabled);
  }

  void getDisabledHistory() {
    final disabledMemory = pref!.getStringList('disabled') ?? [];
    _disabled = disabledMemory;
  }

  bool isExpanded(String className) {
    return _expandedClasses.contains(className);
  }

  void expandClass(String className) {
    _expandedClasses.add(className);
    notifyListeners();
  }

  void unexpandClass(String className) {
    _expandedClasses.removeWhere((e) => e == className);
    notifyListeners();
  }
}
