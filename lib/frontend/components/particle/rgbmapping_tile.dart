import 'package:auto_size_text/auto_size_text.dart';
import 'package:colorify/backend/abstracts/rgbmapping.dart';
import 'package:colorify/ui/util/text_style.dart';
import 'package:flutter/material.dart';

class RGBMappingTile extends StatelessWidget {
  const RGBMappingTile({
    super.key,
    required this.mapping,
    required this.width,
    required this.onDelete,
  });

  final RGBMapping mapping;
  final void Function() onDelete;
  final double width;

  @override
  Widget build(BuildContext context) {
    final color = Color.fromARGB(255, mapping.r, mapping.g, mapping.b);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Center(
              child: Icon(Icons.auto_awesome_rounded, size: 24, color: Colors.white),
            ),
          ),
          SizedBox(width: 20),
          SizedBox(
            height: 64,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  'RGB (${mapping.r}, ${mapping.g}, ${mapping.b})',
                  style: getStyle(color: Colors.white, size: 18),
                ),
                AutoSizeText(
                  mapping.id,
                  style: getStyle(color: Colors.white70, size: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
