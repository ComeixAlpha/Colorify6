import 'package:colorify/ui/basic/xmenu.dart';
import 'package:colorify/ui/util/text_style.dart';
import 'package:flutter/material.dart';

class ISelectionTile extends StatefulWidget {
  final double width;
  final double height;
  final String title;
  final String subtitle;
  final int initValue;
  final List<String> candidates;
  final void Function(int) onSelect;
  const ISelectionTile({
    super.key,
    required this.width,
    required this.height,
    required this.title,
    required this.subtitle,
    required this.initValue,
    required this.candidates,
    required this.onSelect,
  });

  @override
  State<ISelectionTile> createState() => _ISelectionTileState();
}

class _ISelectionTileState extends State<ISelectionTile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                color: const Color(0xFF2d2a31),
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 1,
                    spreadRadius: 1,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AnimatedContainer(
                        curve: Curves.ease,
                        duration: const Duration(
                          milliseconds: 240,
                        ),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: const Color(0xFFAED581),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        widget.title,
                        style: getStyle(
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: widget.width - 20,
                    height: 30,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.subtitle,
                        overflow: TextOverflow.ellipsis,
                        style: getStyle(
                          color: Colors.grey,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                  XMenu(
                    initValue: widget.initValue,
                    tiles: widget.candidates,
                    width: widget.width - 20,
                    height: 50,
                    gapHeight: 8,
                    backgroundColor: const Color(0xFF26232a),
                    splashColor: Colors.white.withOpacity(0.1),
                    hoverColor: const Color(0xFF6b6276),
                    textStyle: getStyle(color: Colors.white, size: 18),
                    duration: const Duration(milliseconds: 180),
                    onSelect: (v) => widget.onSelect(v),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
