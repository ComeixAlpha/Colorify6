import 'package:colorify/backend/abstracts/palette_entry.dart';
import 'package:colorify/backend/providers/block.prov.dart';
import 'package:colorify/frontend/components/block/block_palette_tile.dart';
import 'package:colorify/frontend/components/block/palette_searchfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BlockPalette extends StatefulWidget {
  final double width;
  final double height;
  const BlockPalette({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  State<BlockPalette> createState() => _BlockPaletteState();
}

class _BlockPaletteState extends State<BlockPalette> {
  String _filter = '';

  @override
  Widget build(BuildContext context) {
    final blockprov = context.watch<Blockprov>();

    List<BlockPaletteEntry> palette = [...blockprov.palette];

    if (_filter.isNotEmpty) {
      palette = palette.where((e) => e.id.contains(_filter) || e.cn.contains(_filter)).toList();
    }

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          PaletteSearchfield(
            width: widget.width - 20,
            height: 70,
            onChanged: (v) => setState(() {
              _filter = v;
            }),
          ),
          SizedBox(
            height: widget.height - 100,
            child: ListView.builder(
              itemCount: palette.length + 1,
              padding: const EdgeInsets.all(0),
              itemBuilder: (_, i) {
                if (i == palette.length) {
                  return const SizedBox(height: 100);
                }
                final entry = palette[i];
                return BlockPaletteTile(
                  width: widget.width,
                  entry: entry,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
