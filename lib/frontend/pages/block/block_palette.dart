import 'package:colorify/backend/abstracts/palette_entry.dart';
import 'package:colorify/backend/palette/palette.block.classify.dart';
import 'package:colorify/backend/providers/block.prov.dart';
import 'package:colorify/frontend/components/block/block_palette_class_head.dart';
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

  bool _notAnyClass(String id) {
    for (List<String> thisClass in classes.values) {
      if (thisClass.contains(id)) {
        return true;
      }
    }
    return false;
  }

  List<Widget> _buildChildren(List<BlockPaletteEntry> allEntries) {
    List<Widget> children = [];

    final blockprov = context.watch<Blockprov>();

    for (int i = 0; i < classes.keys.length; i++) {
      final className = classes.keys.toList()[i];
      children.add(
        BlockPaletteClassHead(
          width: widget.width,
          className: className,
          onChanged: (v) {
            if (v) {
              blockprov.expandClass(className);
            } else {
              blockprov.unexpandClass(className);
            }
          },
        ),
      );
      if (blockprov.expandedClasses.contains(className)) {
        for (BlockPaletteEntry entry in allEntries) {
          final thisClass = classes[className]!;
          if (thisClass.contains(entry.id)) {
            children.add(BlockPaletteTile(width: widget.width, entry: entry));
          }
        }
      }
    }

    children.add(
      BlockPaletteClassHead(
        width: widget.width,
        className: '其他',
        onChanged: (v) {
          if (v) {
            blockprov.expandClass('其他');
          } else {
            blockprov.unexpandClass('其他');
          }
        },
      ),
    );
    if (blockprov.expandedClasses.contains('其他')) {
      for (BlockPaletteEntry entry in allEntries) {
        if (!_notAnyClass(entry.id)) {
          children.add(BlockPaletteTile(width: widget.width, entry: entry));
        }
      }
    }

    /// Padding
    children.add(const SizedBox(height: 100));

    return children;
  }

  @override
  Widget build(BuildContext context) {
    final blockprov = context.watch<Blockprov>();

    blockprov.getDisabledHistory();

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
          LayoutBuilder(
            builder: (_, __) {
              if (blockprov.carpetOnly || blockprov.stairType) {
                return SizedBox(
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
                );
              } else {
                return SizedBox(
                  height: widget.height - 100,
                  child: ListView(
                    padding: const EdgeInsets.all(0),
                    children: _buildChildren(palette),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
