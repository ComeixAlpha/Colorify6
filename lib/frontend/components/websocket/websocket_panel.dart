import 'package:colorify/frontend/scaffold/colors.dart';
import 'package:colorify/ui/util/text_style.dart';
import 'package:flutter/material.dart';

enum WebSocketPanelStyle { container, leading }

class WebSocketPanel extends StatelessWidget {
  final double width;
  final double height;
  final String title;
  final String hint;
  final Widget child;
  final WebSocketPanelStyle style;
  const WebSocketPanel({
    super.key,
    required this.width,
    required this.height,
    required this.title,
    this.hint = '',
    required this.child,
    this.style = WebSocketPanelStyle.container,
  });

  @override
  Widget build(BuildContext context) {
    if (style == WebSocketPanelStyle.container) {
      return Column(
        children: [
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: MyTheme.card,
              borderRadius: BorderRadius.circular(4),
            ),
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [Text(title, style: getStyle(color: Colors.white, size: 18))],
                ),
                if (hint.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [Text(hint, style: getStyle(color: Colors.grey, size: 16))],
                  ),
                child,
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      );
    } else {
      return Column(
        children: [
          Container(
            width: width,
            decoration: BoxDecoration(
              color: MyTheme.card,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(4),
                topLeft: Radius.circular(4),
              ),
            ),
            child: Padding(
              padding: EdgeInsetsGeometry.all(12.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(title, style: getStyle(color: Colors.white, size: 18)),
              ),
            ),
          ),
          child,
        ],
      );
    }
  }
}
