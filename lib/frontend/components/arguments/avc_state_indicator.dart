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
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 240),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      child: widget.state
          ? const Icon(
              key: ValueKey(1),
              Icons.done_all_rounded,
              color: Color(0xFFAED581),
              size: 16,
            )
          : const Icon(
              key: ValueKey(2),
              Icons.close_rounded,
              color: Color(0xFFEF5350),
              size: 16,
            ),
      transitionBuilder: (child, animation) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}
