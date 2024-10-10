import 'package:colorify/ui/basic/xtextfield.dart';
import 'package:colorify/ui/util/text_style.dart';
import 'package:flutter/material.dart';

class IStringTile extends StatefulWidget {
  final double width;
  final double height;
  final String title;
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
  bool _avcPassed = true;

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
                color: const Color(0xFF2d2a31),
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 1,
                    spreadRadius: 1,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AnimatedContainer(
                        curve: Curves.ease,
                        duration: const Duration(
                          milliseconds: 240,
                        ),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: _avcPassed ? const Color(0xFFAED581) : const Color(0xFFEF5350),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        widget.title,
                        style: getStyle(
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                  XTextfield(
                    controller: widget.controller,
                    width: widget.width - 20.0,
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
                      if (res != _avcPassed) {
                        setState(() {
                          _avcPassed = res;
                        });
                      }
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
