import 'dart:io' as stdio;
import 'dart:typed_data';

import 'package:colorify/backend/utils/minecraft/ws_datapacker.dart';

typedef NetAdd = stdio.InternetAddress;

/// Minecraft WebSocket controller
final class WebSocket {
  /// Changes when server launching/closing.
  /// [HttpServer] while server is running.
  /// [Null] while server is sleeping.
  Object? _server;

  /// Static default server address.
  final NetAdd _address = NetAdd.fromRawAddress(Uint8List.fromList([127, 0, 0, 1]));

  /// Static default server port.
  final int _port = 8080;

  /// Connected channels.
  final List<stdio.WebSocket> _channels = [];

  /// Records if callback functions are inited
  bool _inited = false;

  /// Triggers when a new channel has joined.
  late final void Function(stdio.WebSocket)? onJoin;

  /// Triggers when received messages from any channel.
  late final void Function(dynamic)? onMessage;

  /// Triggers when [Unknown].
  late final void Function()? onDone;

  /// Triggers when an error has occured on one channel.
  late final void Function()? onError;

  /// Singleton constructor

  WebSocket._privateConstructor();

  static final WebSocket _instance = WebSocket._privateConstructor();

  factory WebSocket() {
    return _instance;
  }

  /// Inits callback functions for channels
  void initCallbacks({
    required Function(stdio.WebSocket)? onJoin,
    required Function(dynamic)? onMessage,
    required Function()? onDone,
    required Function()? onError,
  }) {
    if (_inited) {
      return;
    }
    this.onJoin = onJoin;
    this.onMessage = onMessage;
    this.onDone = onDone;
    this.onError = onError;
    _inited = true;
  }

  /// Launchs server at local 127.0.0.1:8080.
  /// Fails when server has already launched.
  /// Throws when server has already launched.
  Future<void> launch() async {
    assert(_server == null);
    final stdio.HttpServer server = await stdio.HttpServer.bind(_address, _port);
    _server = server;
    server.listen(
      (stdio.HttpRequest request) {
        if (stdio.WebSocketTransformer.isUpgradeRequest(request)) {
          _handleWebSocket(request);
        } else {
          request.response
            ..statusCode = stdio.HttpStatus.notFound
            ..write('Not Found');
          request.response.close();
        }
      },
    );
  }

  /// Drops connection from local server on 127.0.0.1:8080.
  /// Fails when server has already closed.
  /// Throws when server has already closed.
  Future<void> close() async {
    assert(_server != null);

    for (var c in _channels) {
      () async => await c.close();
    }

    await (_server as stdio.HttpServer).close();
    _server = null;
  }

  /// Handles http request from local server on 127.0.0.1:8080.
  /// Pushs the WebSocket channel object into private channel list
  /// for commands' broadcasting.
  /// Listens for events from each channel.
  Future<void> _handleWebSocket(stdio.HttpRequest request) async {
    final channel = await stdio.WebSocketTransformer.upgrade(request);

    _channels.add(channel);

    if (onJoin != null) {
      onJoin!(channel);
    }

    channel.listen(
      onMessage,
      onDone: onDone,
      cancelOnError: true,
    );
  }

  /// Broadcasts a single command request to each channel
  /// that has been connected.
  /// Receives [command] in String and automatically tranfrom it
  /// into command request datapack in json.
  Future<void> broadcastCommand(String command) async {
    for (stdio.WebSocket channel in _channels) {
      channel.add(DatapackUtilities.commandRequest(command));
    }
  }
}
