import 'package:colorify/backend/providers/block.prov.dart';
import 'package:colorify/ui/util/text_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BlockPaletteClassHead extends StatefulWidget {
  final double width;
  final String className;
  final void Function(bool) onChanged;
  const BlockPaletteClassHead({
    super.key,
    required this.width,
    required this.className,
    required this.onChanged,
  });

  @override
  State<BlockPaletteClassHead> createState() => _BlockPaletteClassHeadState();
}

class _BlockPaletteClassHeadState extends State<BlockPaletteClassHead> {
  bool _expand = false;

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
        widget.onChanged(_expand);
      },
      child: Column(
        children: [
          Container(
            width: widget.width - 24,
            height: 50,
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.className,
                  style: getStyle(
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                AnimatedRotation(
                  turns: _expand ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 120),
                  curve: Curves.ease,
                  child: const Icon(
                    Icons.expand_less,
                    color: Colors.white,
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
