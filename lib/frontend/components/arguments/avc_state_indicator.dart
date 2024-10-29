import 'package:flutter/material.dart';

class AvcStateIndicator extends StatefulWidget {
  final bool state;
  const AvcStateIndicator({super.key, required this.state});

  @override
  State<AvcStateIndicator> createState() => _AvcStateIndicatorState();
}

class _AvcStateIndicatorState extends State<AvcStateIndicator> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      curve: Curves.ease,
      duration: const Duration(
        milliseconds: 240,
      ),
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: widget.state ? const Color(0xFFAED581) : const Color(0xFFEF5350),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
