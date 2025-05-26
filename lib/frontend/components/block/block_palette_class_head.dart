import 'package:colorify/backend/providers/block.prov.dart';
import 'package:colorify/ui/util/text_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BlockPaletteClassHead extends StatefulWidget {
  final double width;
  final String className;
  final String classSubname;
  final bool isExpanded;
  final void Function(bool) onExpandStateChanged;
  const BlockPaletteClassHead({
    super.key,
    required this.width,
    required this.className,
    required this.classSubname,
    required this.isExpanded,
    required this.onExpandStateChanged,
  });

  @override
  State<BlockPaletteClassHead> createState() => _BlockPaletteClassHeadState();
}

class _BlockPaletteClassHeadState extends State<BlockPaletteClassHead> {
  bool _expand = false;

  @override
  void initState() {
    _expand = widget.isExpanded;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final blockprov = context.watch<Blockprov>();
    if (blockprov.expandedClasses.contains(widget.className)) {
      _expand = true;
    }
    return GestureDetector(
      onTap: () {
        setState(() {
          _expand = !_expand;
        });
        widget.onExpandStateChanged(_expand);
      },
      child: Column(
        children: [
          Container(
            width: widget.width - 24,
            decoration: BoxDecoration(
              color: const Color(0xFF2d2a31),
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(77),
                  blurRadius: 5,
                  spreadRadius: 1,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.className,
                      style: getStyle(
                        color: Colors.white.withAlpha(204),
                        size: 18,
                      ),
                    ),
                    Text(
                      widget.classSubname,
                      style: getStyle(
                        color: Colors.grey.withAlpha(204),
                        size: 16,
                      ),
                    ),
                  ],
                ),
                AnimatedRotation(
                  turns: _expand ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 120),
                  curve: Curves.ease,
                  child: const Icon(
                    Icons.expand_less,
                    color: Colors.grey,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
