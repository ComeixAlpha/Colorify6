import 'package:colorify/frontend/components/arguments/avc_state_indicator.dart';
import 'package:colorify/frontend/scaffold/colors.dart';
import 'package:colorify/ui/basic/xtextfield.dart';
import 'package:colorify/ui/util/text_style.dart';
import 'package:flutter/material.dart';

class IStringTile extends StatefulWidget {
  final double width;
  final double height;
  final String title;
  final String subtitle;
  final bool avcState;
  final TextEditingController controller;
  final bool Function(String) examer;
  final void Function(bool) onUpdateAVC;
  final TextInputType? inputType;
  final String? hintText;
  final TextStyle? hintStyle;
  const IStringTile({
    super.key,
    required this.width,
    required this.height,
    required this.title,
    required this.subtitle,
    required this.avcState,
    required this.controller,
    required this.examer,
    required this.onUpdateAVC,
    this.inputType,
    this.hintText,
    this.hintStyle,
  });

  @override
  State<IStringTile> createState() => _IStringTileState();
}

class _IStringTileState extends State<IStringTile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                // color: const Color(0xFF2d2a31),
                color: MyTheme.card,
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AvcStateIndicator(state: widget.avcState),
                      const SizedBox(width: 10),
                      Text(widget.title, style: getStyle(color: Colors.white, size: 22)),
                    ],
                  ),
                  SizedBox(
                    width: widget.width - 20,
                    height: 30,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.subtitle,
                        overflow: TextOverflow.ellipsis,
                        style: getStyle(color: Colors.grey, size: 16),
                      ),
                    ),
                  ),
                  XTextfield(
                    controller: widget.controller,
                    width: widget.width - 20,
                    textInputType: widget.inputType,
                    style: XTextfieldStyle(
                      hintText: widget.hintText,
                      hintStyle: widget.hintStyle,
                    ),
                    onChanged: (v) {
                      bool res = widget.examer(v);
                      if (widget.controller.text.isEmpty) {
                        res = true;
                      }
                      widget.onUpdateAVC(res);
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
