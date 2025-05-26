import 'dart:async';

import 'package:colorify/ui/basic/xbutton.dart';
import 'package:flutter/material.dart';

class GenerateButton extends StatefulWidget {
  final void Function() onTap;
  const GenerateButton({super.key, required this.onTap});

  @override
  State<GenerateButton> createState() => _GenerateButtonState();
}

class _GenerateButtonState extends State<GenerateButton> {
  double rot = 0.0;

  @override
  Widget build(BuildContext context) {
    if (rot == 0.0) {
      Timer(
        const Duration(seconds: 1),
        () => setState(() {
          rot = 0.5;
        }),
      );
    } else if (rot == 0.5) {
      Timer(
        const Duration(milliseconds: 1),
        () => setState(() {
          rot = 1.0;
        }),
      );
    } else if (rot == 1.0) {
      Timer(
        const Duration(seconds: 1),
        () => setState(() {
          rot = 0.0;
        }),
      );
    }

    return XButton(
      width: 60,
      height: 60,
      borderRadius: BorderRadius.circular(30),
      backgroundColor: const Color(0xFFb9acc9),
      hoverColor: const Color(0xFFb9acc9),
      splashColor: Colors.white.withAlpha(77),
      duration: const Duration(milliseconds: 240),
      onTap: widget.onTap,
      child: AnimatedRotation(
        turns: rot,
        curve: Curves.ease,
        duration: const Duration(milliseconds: 240),
        child: const Icon(
          Icons.bolt,
          color: Color(0xFF433e49),
        ),
      ),
    );
  }
}
