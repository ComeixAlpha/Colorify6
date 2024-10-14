import 'package:colorify/ui/basic/xtextfield.dart';
import 'package:colorify/ui/util/text_style.dart';
import 'package:flutter/material.dart';

class PaletteSearchfield extends StatelessWidget {
  final double width;
  final double height;
  final void Function(String) onChanged;
  const PaletteSearchfield({
    super.key,
    required this.width,
    required this.height,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return XTextfield(
      width: width,
      height: height,
      onChanged: onChanged,
      style: XTextfieldStyle(
        hintText: '通过 ID 搜索',
        hintStyle: getStyle(color: Colors.grey, size: 18),
      ),
    );
  }
}
