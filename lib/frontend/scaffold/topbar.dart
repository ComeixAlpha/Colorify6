import 'package:colorify/ui/util/text_style.dart';
import 'package:flutter/material.dart';

class Topbar extends StatelessWidget {
  final double width;
  final double height;
  const Topbar({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: const Color(0xFF26232a),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'COLORIFY v6',
            style: getStyle(
              color: Colors.white,
              size: 30,
              weight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
