import 'dart:async';

import 'package:colorify/backend/extensions/on_datetime.dart';
import 'package:colorify/backend/utils/websocket.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum WebSocketState {
  unactivated,
  activating,
  unconnected,
  connected,
  pausing,
}

class Socketprov with ChangeNotifier {
  WebSocketState _socketState = WebSocketState.unactivated;

  WebSocketState get socketState => _socketState;

  bool get unactivated => _socketState == WebSocketState.unactivated;
  bool get activating => _socketState == WebSocketState.activating;
  bool get unconnected => _socketState == WebSocketState.unconnected;
  bool get connected => _socketState == WebSocketState.connected;
  bool get pausing => _socketState == WebSocketState.pausing;

  int _speed = 0;
  List<String> _logs = [];

  int get speed => _speed;
  List<String> get logs => _logs;

  bool _onTask = false;
  int _commandSent = 0;
  int _commandUnsend = 0;
  int _commandSentRecord = 0;
  List<String> _cachedCommands = [];

  bool get onTask => _onTask;
  int get commandSent => _commandSent;
  double get progress {
    if (!_onTask && !pausing) return 0.0;
    if (_commandSent == 0) return 0.0;
    return _commandSent / (_commandSent + _commandUnsend);
  }

  void updateState(WebSocketState v) {
    _socketState = v;
    notifyListeners();
  }

  void updateSpeed(int v) {
    _speed = v;
    notifyListeners();
  }

  void appendLog(String log) {
    if (_logs.length == 20) {
      _logs.removeAt(0);
    }
    _logs.add('[${DateTime.now().hmsOnly()}] $log');
    notifyListeners();
  }

  void clearLog() {
    _logs = [];
    notifyListeners();
  }

  void resetTaskRecords() {
    _commandSent = 0;
    _commandUnsend = 0;
    _commandSentRecord = 0;
    _cachedCommands = [];
    notifyListeners();
  }

  void startTask(List<String> commands) {
    if (!connected) return;

    resetTaskRecords();

    _onTask = true;
    _commandUnsend = commands.length;
    notifyListeners();

    processTask(commands);

    _recordSpeed();
  }

  Future<void> _recordSpeed() async {
    if (!_onTask) return;
    Timer(
      const Duration(seconds: 1),
      () {
        _speed = _commandSent - _commandSentRecord;
        _commandSentRecord = _commandSent;
        notifyListeners();
        _recordSpeed();
      },
    );
  }

  Future<void> processTask(List<String> commands) async {
    for (int i = 0; i < commands.length; i++) {
      if (!_onTask) {
        _cachedCommands = commands;
        return;
      }

      await WebSocket().broadcastCommand(commands[i]);
      await WebSocket().broadcastCommand('title @s actionbar ${i + 1} of ${commands.length}');

      _commandSent++;
      _commandUnsend--;
      notifyListeners();

      await Future.delayed(const Duration(milliseconds: 1));
    }
    _onTask = false;
  }

  void stopTask() {
    _onTask = false;
    _socketState = WebSocketState.pausing;
    notifyListeners();
  }

  void continueTask() {
    _onTask = true;
    processTask(_cachedCommands.sublist(_cachedCommands.length - _commandUnsend));

    _recordSpeed();
    _socketState = WebSocketState.connected;
    notifyListeners();
  }

  void killTask() {
    _cachedCommands = [];
    _onTask = false;
    _socketState = WebSocketState.connected;
    notifyListeners();
  }
}
