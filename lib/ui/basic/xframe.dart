import 'dart:async';

import 'package:colorify/ui/hide/comfirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:colorify/ui/hide/message_dialog.dart';

class XFrame extends StatefulWidget {
  final Widget? home;
  const XFrame({
    super.key,
    required this.home,
  });

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static bool _onMessage = false;

  static bool message(String title, {String? subtitle, MessageDialogStyle? style}) {
    if (_onMessage) return false;
    OverlayEntry? oe;
    oe = OverlayEntry(
      builder: (ctx) {
        return MessageDialog(
          title: title,
          subtitle: subtitle,
          style: style,
        );
      },
    );
    navigatorKey.currentState!.overlay!.insert(oe);
    _onMessage = true;
    Timer(
      const Duration(milliseconds: 1130),
      () {
        oe?.remove();
        _onMessage = false;
      },
    );
    return true;
  }

  static void comfirm(String content, void Function(bool) onChoose) async {
    OverlayEntry? oe;
    oe = OverlayEntry(
      builder: (ctx) {
        return ComfirmDialog(
          content: content,
          onChoose: (v) {
            onChoose(v);
            oe?.remove();
          },
        );
      },
    );
    navigatorKey.currentState!.overlay!.insert(oe);
  }

  static void insert(OverlayEntry entry) {
    navigatorKey.currentState!.overlay!.insert(entry);
  }

  @override
  State<XFrame> createState() => _XFrameState();
}

class _XFrameState extends State<XFrame> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: MaterialApp(
        navigatorKey: XFrame.navigatorKey,
        debugShowCheckedModeBanner: false,
        debugShowMaterialGrid: false,
        home: widget.home,
      ),
    );
  }
}
