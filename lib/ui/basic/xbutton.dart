import 'package:flutter/material.dart';

class XButton extends StatefulWidget {
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? hoverColor;
  final Duration? duration;
  final Color? splashColor;
  final BorderRadius? borderRadius;
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final void Function()? onTap;
  const XButton({
    super.key,
    this.width = 40.0,
    this.height = 20.0,
    this.backgroundColor = Colors.white,
    this.hoverColor = Colors.white,
    this.duration,
    this.splashColor = Colors.grey,
    this.borderRadius,
    this.padding,
    this.child,
    this.onTap,
  });

  @override
  State<XButton> createState() => _XButtonState();
}

class _XButtonState extends State<XButton> {
  bool _onHover = false;

  @override
  Widget build(BuildContext context) {
    final borderRadius = widget.borderRadius ?? BorderRadius.circular(4.0);
    final hoverColor = widget.hoverColor ?? Colors.white;
    final duration = widget.duration ?? const Duration(milliseconds: 240);
    final onTap = widget.onTap ?? () {};
    return ClipRRect(
      borderRadius: borderRadius,
      child: AnimatedContainer(
        duration: duration,
        curve: Curves.ease,
        color: _onHover ? hoverColor : widget.backgroundColor,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            onHover: (v) {
              setState(() {
                _onHover = v;
              });
            },
            splashColor: widget.splashColor,
            child: Container(
              width: widget.width,
              height: widget.height,
              padding: widget.padding,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
