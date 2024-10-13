import 'package:auto_size_text/auto_size_text.dart';
import 'package:colorify/frontend/pages/particle/particle_mappings.dart';
import 'package:colorify/ui/basic/xbutton.dart';
import 'package:colorify/ui/util/hsv.dart';
import 'package:colorify/ui/util/text_style.dart';
import 'package:flutter/material.dart';

class RGBMappingTile extends StatelessWidget {
  final double width;
  final RGBMapping mapping;
  final void Function() onDelete;
  const RGBMappingTile({
    super.key,
    required this.mapping,
    required this.width,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final color = Color.fromARGB(255, mapping.r, mapping.g, mapping.b);

    final flColorHSV = HSV.fromColor(color);
    flColorHSV.value = 0.2;

    final contrastColor = flColorHSV.toColor();

    return Column(
      children: [
        SizedBox(
          width: width,
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: width / 6 * 2,
                height: 80,
                child: Center(
                  child: Container(
                    width: width / 6 * 2 - 10,
                    height: 70,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Center(
                      child: Text(
                        '${mapping.r}, ${mapping.g}, ${mapping.b}',
                        style: getStyle(
                          color: contrastColor,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: width / 6 * 0.75,
                height: 80,
                child: const Center(
                  child: Icon(
                    Icons.link,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
              SizedBox(
                width: width / 6 * 2.5,
                height: 80,
                child: Center(
                  child: Container(
                    width: width / 6 * 2.5 - 10,
                    height: 70,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2d2a31),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Center(
                      child: AutoSizeText(
                        mapping.id,
                        overflow: TextOverflow.ellipsis,
                        style: getStyle(
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: width / 6 * 0.75,
                height: 70,
                child: XButton(
                  width: width / 6 * 0.75,
                  height: width / 6 * 0.75,
                  backgroundColor: Colors.transparent,
                  hoverColor: Colors.white.withOpacity(0.3),
                  onTap: onDelete,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
