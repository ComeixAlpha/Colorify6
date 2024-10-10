// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:colorify/ui/basic/xframe.dart';
import 'package:colorify/ui/basic/xbutton.dart';
import 'package:colorify/ui/util/text_style.dart';
import 'package:flutter/material.dart';

class _MenuPopup extends StatefulWidget {
  double? width;
  double? height;
  Color? backgroundColor;
  Color? hoverColor;
  Color? splashColor;
  TextStyle? textStyle;
  Duration? duration;
  final List<String> tiles;
  final void Function(int) onSelect;
  _MenuPopup({
    required this.width,
    required this.height,
    this.backgroundColor,
    this.hoverColor,
    this.splashColor,
    this.textStyle,
    this.duration,
    required this.tiles,
    required this.onSelect,
  });

  @override
  State<_MenuPopup> createState() => _MenuPopupState();
}

class _MenuPopupState extends State<_MenuPopup> {
  int _state = 0;
  bool _rollback = false;

  @override
  Widget build(BuildContext context) {
    widget.width ??= 200;
    widget.height ??= 60;
    widget.duration ??= const Duration(milliseconds: 240);

    if (_state == 0 && !_rollback) {
      Timer(const Duration(milliseconds: 10), () {
        setState(() {
          _state = 1;
        });
        Timer(Duration(milliseconds: widget.duration!.inMilliseconds + 10), () {
          setState(() {
            _state = 2;
          });
        });
      });
    }
    return AnimatedOpacity(
      opacity: _state == 0 ? 0 : 1,
      curve: Curves.ease,
      duration: widget.duration!,
      child: AnimatedContainer(
        curve: Curves.ease,
        duration: widget.duration!,
        width: widget.width,
        height: _state == 0 ? 0 : widget.height! * widget.tiles.length,
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? Colors.black,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Visibility(
          visible: _state == 2,
          child: SizedBox(
            width: widget.width,
            height: widget.height! * widget.tiles.length,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                widget.tiles.length,
                (i) {
                  return SizedBox(
                    width: widget.width,
                    height: widget.height,
                    child: Center(
                      child: XButton(
                        width: widget.width! - 12,
                        height: widget.height! - 12,
                        hoverColor: widget.hoverColor,
                        splashColor: widget.splashColor,
                        onTap: () {
                          setState(() {
                            _rollback = true;
                            _state = 1;
                            Timer(const Duration(milliseconds: 10), () {
                              if (!mounted) return;
                              setState(() {
                                _state = 0;
                              });
                              Timer(widget.duration!, () {
                                widget.onSelect(i);
                              });
                            });
                          });
                        },
                        backgroundColor: widget.backgroundColor,
                        child: Center(
                          child: Text(
                            widget.tiles[i],
                            style: widget.textStyle,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class XMenu extends StatefulWidget {
  double? width;
  double? height;
  Color? backgroundColor;
  Color? hoverColor;
  Color? splashColor;
  Duration? duration;
  double? gapHeight;
  TextStyle? textStyle;
  final List<String> tiles;
  final void Function(int) onSelect;
  XMenu({
    super.key,
    this.width,
    this.height,
    this.backgroundColor,
    this.hoverColor,
    this.splashColor,
    this.duration,
    this.gapHeight = 20,
    this.textStyle,
    required this.tiles,
    required this.onSelect,
  });

  @override
  State<XMenu> createState() => _XMenuState();
}

class _XMenuState extends State<XMenu> {
  final GlobalKey _key = GlobalKey();

  OverlayEntry? _overlayEntry;

  bool _onPopup = false;
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    widget.width ??= 200;
    widget.height ??= 60;
    widget.textStyle ??= getStyle(color: Colors.black, size: 18);
    return XButton(
      key: _key,
      width: widget.width,
      height: widget.height,
      backgroundColor: widget.backgroundColor,
      hoverColor: widget.hoverColor,
      splashColor: widget.splashColor,
      onTap: () {
        if (_onPopup) return;
        _overlayEntry = OverlayEntry(
          builder: (ctx) {
            final renderbox = _key.currentContext!.findRenderObject() as RenderBox;
            final offset = renderbox.localToGlobal(Offset.zero);
            return Positioned(
              left: offset.dx,
              top: offset.dy + renderbox.size.height + (widget.gapHeight ?? 0),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 1,
                      spreadRadius: 1,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: _MenuPopup(
                  width: widget.width,
                  height: widget.height,
                  tiles: widget.tiles,
                  backgroundColor: widget.backgroundColor,
                  hoverColor: widget.hoverColor,
                  splashColor: widget.splashColor,
                  textStyle: widget.textStyle,
                  duration: widget.duration,
                  onSelect: (i) {
                    widget.onSelect(i);
                    _overlayEntry?.remove();
                    setState(() {
                      _onPopup = false;
                      _selected = i;
                    });
                  },
                ),
              ),
            );
          },
        );
        XFrame.insert(_overlayEntry!);
        setState(() {
          _onPopup = true;
        });
      },
      child: Center(
        child: Text(
          widget.tiles[_selected],
          style: widget.textStyle,
        ),
      ),
    );
  }
}
