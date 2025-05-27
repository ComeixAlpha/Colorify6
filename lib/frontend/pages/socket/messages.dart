import 'package:colorify/ui/util/text_style.dart';
import 'package:flutter/material.dart';

class SocketMessages extends StatefulWidget {
  final double width;
  final double height;
  final List<String> logs;
  const SocketMessages({
    super.key,
    required this.width,
    required this.height,
    required this.logs,
  });

  @override
  State<SocketMessages> createState() => _SocketMessagesState();
}

class _SocketMessagesState extends State<SocketMessages> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(4),
      ),
      child: ListView.builder(
        itemCount: widget.logs.length,
        itemBuilder: (_, index) {
          return Text(
            widget.logs[index],
            style: getStyle(
              size: 14,
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }
}
