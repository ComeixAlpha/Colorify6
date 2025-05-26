import 'package:colorify/ui/util/text_style.dart';
import 'package:flutter/material.dart';

class Wstile extends StatelessWidget {
  final double width;
  final double height;
  final String title;
  final Widget child;
  const Wstile({
    super.key,
    required this.width,
    required this.height,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: const Color(0xFF2d2a31),
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(77),
                blurRadius: 1,
                spreadRadius: 1,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: getStyle(
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ],
              ),
              child,
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
