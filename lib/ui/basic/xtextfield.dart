import 'package:colorify/ui/util/text_style.dart';
import 'package:flutter/material.dart';

class XTextfieldStyle {
  TextStyle? textStyle;
  TextStyle? hintStyle;
  double? borderWidth;
  Color? focusColor;
  Color? enabledColor;
  Color? cursorColor;
  String? hintText;

  XTextfieldStyle({
    this.textStyle,
    this.hintStyle,
    this.focusColor,
    this.enabledColor,
    this.cursorColor,
    this.hintText,
  }) {
    textStyle ??= getStyle(color: Colors.white, size: 18, weight: FontWeight.w300);
    borderWidth ??= 2.0;
    focusColor ??= const Color(0xFF777085);
    enabledColor ??= const Color(0xFF333039);
    cursorColor ??= Colors.white;
  }
}

class XTextfield extends StatefulWidget {
  final double? width;
  final double? height;
  final TextEditingController? controller;
  final TextInputType? textInputType;
  final void Function(String)? onChanged;
  final XTextfieldStyle? style;
  const XTextfield({
    super.key,
    this.width,
    this.height,
    this.controller,
    this.textInputType,
    this.onChanged,
    this.style,
  });

  @override
  State<XTextfield> createState() => _XTextfieldState();
}

class _XTextfieldState extends State<XTextfield> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.style ?? XTextfieldStyle();
    return Material(
      color: Colors.transparent,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: Center(
          child: TextField(
            controller: widget.controller,
            style: style.textStyle,
            onChanged: widget.onChanged,
            keyboardType: widget.textInputType,
            focusNode: _focusNode,
            onTapOutside: (v) {
              _focusNode.unfocus();
            },
            decoration: InputDecoration(
              hintText: style.hintText,
              hintStyle: style.hintStyle,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: style.borderWidth!,
                  color: style.focusColor!,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: style.borderWidth!,
                  color: style.enabledColor!,
                ),
              ),
            ),
            cursorColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
