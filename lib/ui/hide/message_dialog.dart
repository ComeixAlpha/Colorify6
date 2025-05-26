import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:colorify/ui/util/text_style.dart';
import 'package:flutter/material.dart';

class MessageDialogStyle {
  final double? width;
  final double? height;
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final Color? color;
  TextStyle? titleStyle;
  TextStyle? subtitleStyle;
  EdgeInsets? padding;
  List<BoxShadow>? boxshadow;
  final Widget? leading;
  final double borderRadius;

  MessageDialogStyle({
    this.width = 200.0,
    this.height = 60.0,
    this.top,
    this.bottom,
    this.left,
    this.right,
    this.color = Colors.black,
    this.titleStyle,
    this.subtitleStyle,
    this.padding,
    this.leading,
    this.borderRadius = 4.0,
  }) {
    titleStyle ??= getStyle(
      color: Colors.white,
      size: 18,
    );
    subtitleStyle ??= getStyle(
      color: Colors.white,
      size: 14,
    );
    padding ??= const EdgeInsets.symmetric(horizontal: 8, vertical: 6);
    boxshadow ??= [
      BoxShadow(
        color: Colors.black.withAlpha(51),
        blurRadius: 0.1,
        spreadRadius: 1,
        offset: const Offset(0.0, 2),
      )
    ];
  }
}

/// Dialog displays text infomation
///
/// Invoke with XFrame.message(title, subtitle: subtitle)
class MessageDialog extends StatefulWidget {
  final String? title;
  final String? subtitle;
  final Duration? animationDuration;
  final MessageDialogStyle? style;
  const MessageDialog({
    super.key,
    this.title,
    this.subtitle,
    this.animationDuration,
    this.style,
  });

  @override
  State<MessageDialog> createState() => _MessageDialogState();
}

class _MessageDialogState extends State<MessageDialog> {
  /// Message Dialog Popup Animation State
  ///
  /// 0: Appear as unseeable (opacity 0) widget sticking to the left edge (0 distance)
  /// , ${widget.toTopDistance} from the top edge.
  ///
  /// 1: Animated to ${widget.toRightDistance} from the left edge, same distance to the
  /// top as state 0. Unfold dialog, opacity animated to 1.
  ///
  /// 2: Disappear with fold and fading (opacity change) animation.
  ///
  int _animationState = 0;

  /// Animation transition timer
  Timer? timer;

  /// Cancels timer when dispose
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// Delayed animation state controller
    if (_animationState == 0) {
      timer = Timer(
        const Duration(milliseconds: 10),
        () {
          setState(() {
            _animationState = 1;
          });
        },
      );
    } else if (_animationState == 1) {
      timer = Timer(
        const Duration(milliseconds: 1000),
        () {
          if (mounted) {
            setState(() {
              _animationState = 2;
            });
          }
        },
      );
    }

    /// Dialog style
    final style = widget.style ?? MessageDialogStyle();
    final animationDuration =
        widget.animationDuration ?? const Duration(milliseconds: 120);
    return AnimatedPositioned(
      duration: animationDuration,
      curve: Curves.ease,
      top: style.top,
      bottom: style.bottom,
      left: style.left,
      right: style.right,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          boxShadow: style.boxshadow,
        ),
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            /// Dialog
            AnimatedOpacity(
              opacity: _animationState == 0 ? 0.0 : (_animationState == 1 ? 1.0 : 0.0),
              duration: animationDuration,
              curve: Curves.ease,
              child: Row(
                children: [
                  /// Leading
                  style.leading ??
                      Container(
                        width: 20.0,
                        height: style.height,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 236, 104, 95),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(style.borderRadius),
                            bottomLeft: Radius.circular(style.borderRadius),
                          ),
                        ),
                      ),

                  /// Text info
                  AnimatedContainer(
                    duration: animationDuration,
                    curve: Curves.ease,
                    width: _animationState == 0
                        ? 0.0
                        : (_animationState == 1 ? style.width : 0.0),
                    height: style.height,
                    decoration: BoxDecoration(
                      color: style.color,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(style.borderRadius),
                        bottomRight: Radius.circular(style.borderRadius),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Title
                        AutoSizeText(
                          widget.title ?? '',
                          overflow: TextOverflow.ellipsis,
                          style: style.titleStyle,
                        ),

                        /// Subtitle
                        AutoSizeText(
                          widget.subtitle ?? '',
                          overflow: TextOverflow.ellipsis,
                          style: style.subtitleStyle,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            /// White splash
            AnimatedOpacity(
              opacity: _animationState == 0 ? 1.0 : 0.0,
              duration: Duration(milliseconds: animationDuration.inMilliseconds + 300),
              curve: Curves.ease,
              child: AnimatedContainer(
                duration: animationDuration,
                curve: Curves.ease,
                width: _animationState == 0
                    ? 0.0
                    : (_animationState == 1 ? style.width : 0.0),
                height: style.height,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(style.borderRadius),
                    bottomRight: Radius.circular(style.borderRadius),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
