import 'dart:async';

import 'package:flutter/material.dart';
import 'package:colorify/ui/basic/xframe.dart';
import 'package:colorify/ui/util/text_style.dart';

class _FadingTip extends StatefulWidget {
  final String tip;
  const _FadingTip({required this.tip});

  @override
  State<_FadingTip> createState() => _FadingTipState();
}

class _FadingTipState extends State<_FadingTip> {
  int _state = 0;

  @override
  Widget build(BuildContext context) {
    if (_state == 0) {
      Timer(
        const Duration(milliseconds: 10),
        () {
          if (mounted) {
            setState(() {
              _state = 1;
            });
          }
        },
      );
    }

    final painter = TextPainter(
      text: TextSpan(
        text: widget.tip,
        style: getStyle(
          color: Colors.white,
          size: 14.0,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    return Stack(
      children: [
        AnimatedOpacity(
          opacity: _state == 0 ? 0.0 : 1.0,
          duration: const Duration(milliseconds: 240),
          curve: Curves.ease,
          child: Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: const Color(0xFF312e38),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Center(
              child: Text(
                widget.tip,
                style: getStyle(
                  color: Colors.white,
                  size: 14.0,
                ),
              ),
            ),
          ),
        ),
        AnimatedOpacity(
          opacity: _state == 0 ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 240),
          child: Container(
            width: painter.width + 24.0,
            height: painter.height + 24.0,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(4.0),
            ),
          ),
        ),
      ],
    );
  }
}

class XTooltip extends StatefulWidget {
  final String tip;
  final Widget child;
  const XTooltip({
    super.key,
    required this.tip,
    required this.child,
  });

  @override
  State<XTooltip> createState() => _XTooltipState();
}

class _XTooltipState extends State<XTooltip> {
  final GlobalKey _globalKey = GlobalKey();

  OverlayEntry? overlayEntry;

  RenderBox? _renderBox;

  bool _onHover = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox renderBox = _globalKey.currentContext!.findRenderObject() as RenderBox;
      setState(() {
        _renderBox = renderBox;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      key: _globalKey,
      onHover: (v) {
        if (_onHover) return;
        final offset = _renderBox!.localToGlobal(Offset.zero);
        overlayEntry = OverlayEntry(
          builder: (ctx) {
            return Positioned(
              top: offset.dy - 20.0,
              left: offset.dx + _renderBox!.size.width - 12.0,
              child: _FadingTip(tip: widget.tip),
            );
          },
        );
        XFrame.insert(overlayEntry!);
        setState(() {
          _onHover = true;
        });
      },
      onExit: (v) {
        overlayEntry?.remove();
        setState(() {
          _onHover = false;
        });
      },
      child: widget.child,
    );
  }
}
