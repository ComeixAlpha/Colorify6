import 'package:colorify/frontend/pages/about/about.dart';
import 'package:colorify/ui/basic/xbutton.dart';
import 'package:colorify/ui/util/text_style.dart';
import 'package:flutter/cupertino.dart';
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
    final tp = TextPainter(
      text: TextSpan(
        text: 'COLORIFY v6',
        style: getStyle(
          color: Colors.white,
          size: 30,
          weight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    return Container(
      width: width,
      height: height,
      color: const Color(0xFF26232a),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              Text(
                'COLORIFY ',
                style: getStyle(
                  color: Colors.white,
                  size: 30,
                  weight: FontWeight.w700,
                ),
              ),
              Text(
                'v6',
                style: getStyle(
                  color: Colors.white.withOpacity(0.3),
                  size: 30,
                  weight: FontWeight.w700,
                ),
              ),
            ],
          ),
          XButton(
            width: tp.height,
            height: tp.height,
            backgroundColor: Colors.transparent,
            hoverColor: Colors.white.withOpacity(0.2),
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (BuildContext ctx) {
                    return const About();
                  },
                ),
              );
            },
            borderRadius: BorderRadius.circular(tp.height / 2),
            child: const Center(
              child: Icon(
                Icons.book,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
