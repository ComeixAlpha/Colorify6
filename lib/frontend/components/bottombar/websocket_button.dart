import 'dart:async';

import 'package:colorify/backend/providers/socket.prov.dart';
import 'package:colorify/frontend/components/bottombar/bottombar_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WebsocketButton extends StatefulWidget {
  final void Function() onTap;
  const WebsocketButton({
    super.key,
    required this.onTap,
  });

  @override
  State<WebsocketButton> createState() => _WebsocketButtonState();
}

class _WebsocketButtonState extends State<WebsocketButton> {
  /// Breath State
  /// 0: appear
  /// 1: disappear
  int _state = 0;

  @override
  Widget build(BuildContext context) {
    final socketprov = context.watch<Socketprov>();

    Color backgroundColor = const Color(0xFFb9acc9);
    Color iconColor = Colors.black;
    Color hoverColor = const Color(0xFFe7d3ff);
    Color? splashColor = const Color(0xFFeadaff);

    if (socketprov.unactivated || socketprov.activating) {
      backgroundColor = Colors.transparent;
      iconColor = Colors.white;
      hoverColor = Colors.white.withOpacity(0.3);
      splashColor = null;
    }

    if (socketprov.unactivated) {
      iconColor = Colors.white.withOpacity(0.3);
    }

    if (socketprov.unconnected) {
      if (_state == 0) {
        Timer(
          const Duration(seconds: 1),
          () => setState(
            () {
              _state = 1;
            },
          ),
        );
      }
      if (_state == 1) {
        backgroundColor = Colors.transparent;
        Timer(
          const Duration(seconds: 1),
          () => setState(
            () {
              _state = 0;
            },
          ),
        );
      }
    }

    if (socketprov.connected) {
      backgroundColor = const Color(0xFFAED581);
      iconColor = Colors.white;
    }

    return BottombarButton(
      color: backgroundColor,
      iconColor: iconColor,
      splashColor: splashColor,
      hoverColor: hoverColor,
      icon: Icons.sensors_rounded,
      duration: const Duration(milliseconds: 800),
      onTap: widget.onTap,
    );
  }
}
