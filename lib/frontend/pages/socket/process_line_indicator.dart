import 'package:flutter/material.dart';

class ProcessLineIndicator extends StatefulWidget {
  final double width;
  final double height;
  final double progress;
  const ProcessLineIndicator({
    super.key,
    required this.width,
    required this.height,
    required this.progress,
  });

  @override
  State<ProcessLineIndicator> createState() => _ProcessLineIndicatorState();
}

class _ProcessLineIndicatorState extends State<ProcessLineIndicator> {
  static const double height = 4;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Center(
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
              width: widget.width - 20,
              height: height,
              decoration: BoxDecoration(
                color: const Color(0xFF1d1a1f),
                borderRadius: BorderRadius.circular(height / 2),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 240),
              curve: Curves.ease,
              child: Container(
                width: 0 + widget.progress * (widget.width - 20),
                height: height,
                decoration: BoxDecoration(
                  color: const Color(0xFFAED581),
                  borderRadius: BorderRadius.circular(height / 2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
