import 'package:colorify/backend/abstracts/palette_entry.dart';
import 'package:colorify/backend/assets/palette/palette.block.classify.dart';
import 'package:colorify/backend/providers/block.prov.dart';
import 'package:colorify/frontend/components/block/block_palette_class_head.dart';
import 'package:colorify/frontend/components/block/block_palette_tile.dart';
import 'package:colorify/frontend/components/block/palette_searchfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BlockPalette extends StatefulWidget {
  final double width;
  final double height;
  const BlockPalette({super.key, required this.width, required this.height});

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
      final classNameAll = classes.keys.toList()[i];
      final splited = classNameAll.split(':');
      final className = splited[0];
      final classSubname = splited[1];
      children.add(
        BlockPaletteClassHead(
          width: widget.width,
          className: '[${classes[classes.keys.toList()[i]]!.length}] $className',
          classSubname: classSubname,
          isExpanded: blockprov.isExpanded(className),
          onExpandStateChanged: (v) {
            if (v) {
              blockprov.expandClass(className);
            } else {
              blockprov.unexpandClass(className);
            }
          },
        ),
      );
      if (blockprov.expandedClasses.any((e) => e.contains(className))) {
        for (int j = 0; j < allEntries.length; j++) {
          final BlockPaletteEntry entry = allEntries[j];
          final List<String> thisClass = classes[classNameAll]!;
          if (thisClass.contains(entry.id)) {
            children.add(BlockPaletteTile(width: widget.width, entry: entry));
            if (j != allEntries.length - 1) {
              children.add(
                UnconstrainedBox(
                  child: Container(
                    width: widget.width - 40,
                    height: 1,
                    color: Colors.white.withAlpha(26),
                  ),
                ),
              );
            }
          }
        }
      }
    }

    children.add(
      BlockPaletteClassHead(
        width: widget.width,
        className: '其他 Others',
        classSubname: '未分类或无法明确分类',
        isExpanded: blockprov.isExpanded('其他 Others'),
        onExpandStateChanged: (v) {
          if (v) {
            blockprov.expandClass('其他 Others');
          } else {
            blockprov.unexpandClass('其他 Others');
          }
        },
      ),
    );
    if (blockprov.expandedClasses.contains('其他 Others')) {
      for (BlockPaletteEntry entry in allEntries) {
        if (!_notAnyClass(entry.id)) {
          children.add(BlockPaletteTile(width: widget.width, entry: entry));
          children.add(
            UnconstrainedBox(
              child: Container(
                width: widget.width - 40,
                height: 1,
                color: Colors.white.withAlpha(26),
              ),
            ),
          );
        }
      }
    }

    children.removeLast();

    /// Padding
    children.add(const SizedBox(height: 100));

    return children;
  }

  @override
  void initState() {
    final blockprov = context.read<Blockprov>();
    blockprov.getDisabledHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final blockprov = context.watch<Blockprov>();

    List<BlockPaletteEntry> palette = [...blockprov.palette];

    if (_filter.isNotEmpty) {
      palette = palette
          .where((e) => e.id.contains(_filter) || e.cn.contains(_filter))
          .toList();
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
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (_, i) {
                      if (i == palette.length) {
                        return const SizedBox(height: 100);
                      }
                      final entry = palette[i];
                      return BlockPaletteTile(width: widget.width, entry: entry);
                    },
                  ),
                );
              } else {
                return SizedBox(
                  height: widget.height - 100,
                  child: ListView(
                    padding: const EdgeInsets.all(0),
                    physics: const BouncingScrollPhysics(),
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
