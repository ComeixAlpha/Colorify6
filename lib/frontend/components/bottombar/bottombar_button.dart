import 'package:colorify/ui/basic/xbutton.dart';
import 'package:flutter/material.dart';

class BottombarButton extends StatefulWidget {
  final IconData icon;
  final void Function() onTap;
  final Color? color;
  final Color? splashColor;
  final Color? hoverColor;
  final Color? iconColor;
  final Duration? duration;
  const BottombarButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.color,
    this.splashColor,
    this.hoverColor,
    this.iconColor,
    this.duration,
  });

  @override
  State<BottombarButton> createState() => _BottombarButtonState();
}

class _BottombarButtonState extends State<BottombarButton> {
  @override
  Widget build(BuildContext context) {
    return XButton(
      width: 60,
      height: 60,
      borderRadius: BorderRadius.circular(30),
      backgroundColor: widget.color ?? Colors.transparent,
      hoverColor: widget.hoverColor,
      onTap: widget.onTap,
      splashColor: widget.splashColor,
      duration: widget.duration,
      child: Icon(widget.icon, color: widget.iconColor ?? Colors.white),
    );
  }
}
