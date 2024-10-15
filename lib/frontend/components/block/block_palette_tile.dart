import 'package:colorify/backend/abstracts/palette_entry.dart';
import 'package:colorify/backend/providers/block.prov.dart';
import 'package:colorify/ui/basic/xbutton.dart';
import 'package:colorify/ui/util/text_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BlockPaletteTile extends StatefulWidget {
  final double width;
  final BlockPaletteEntry entry;
  const BlockPaletteTile({
    super.key,
    required this.width,
    required this.entry,
  });

  @override
  State<BlockPaletteTile> createState() => _BlockPaletteTileState();
}

class _BlockPaletteTileState extends State<BlockPaletteTile> {
  @override
  Widget build(BuildContext context) {
    final entry = widget.entry;
    final blockprov = Provider.of<Blockprov>(context, listen: false);
    final enabled = !blockprov.disabled.contains(entry.id);
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: widget.width,
              height: 80,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: Center(
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(
                            255,
                            entry.r,
                            entry.g,
                            entry.b,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: LayoutBuilder(
                          builder: (_, __) {
                            if (enabled) {
                              return const SizedBox();
                            } else {
                              return const Expanded(
                                child: Icon(
                                  Icons.block,
                                  size: 60,
                                  color: Colors.white,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        entry.cn,
                        style: getStyle(
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      SizedBox(
                        width: widget.width - 184,
                        child: Text(
                          entry.id,
                          overflow: TextOverflow.ellipsis,
                          style: getStyle(
                            color: Colors.grey,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              right: 10,
              bottom: 20,
              child: XButton(
                width: 80,
                height: 40,
                backgroundColor: enabled ? Colors.transparent : const Color(0xFFEF5350),
                hoverColor: Colors.white.withOpacity(0.1),
                onTap: () {
                  if (enabled) {
                    blockprov.disableWhichIdIs(widget.entry.id);
                    setState(() {});
                  } else {
                    blockprov.enableWhichIdIs(widget.entry.id);
                    setState(() {});
                  }
                },
                child: Center(
                  child: Text(
                    enabled ? '禁用' : '启用',
                    style: getStyle(
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
