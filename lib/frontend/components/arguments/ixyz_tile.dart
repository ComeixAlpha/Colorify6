import 'package:colorify/ui/basic/xtextfield.dart';
import 'package:colorify/ui/util/text_style.dart';
import 'package:flutter/material.dart';

class IXYZTile extends StatefulWidget {
  final double width;
  final double height;
  final String title;
  final String subtitle;
  final List<TextEditingController> controllers;
  final bool Function(String) examer;
  final void Function(bool) onUpdateAVC;
  const IXYZTile({
    super.key,
    required this.width,
    required this.height,
    required this.title,
    required this.subtitle,
    required this.controllers,
    required this.examer,
    required this.onUpdateAVC,
  });

  @override
  State<IXYZTile> createState() => _IXYZTileState();
}

class _IXYZTileState extends State<IXYZTile> {
  final List<bool> _avcPassedList = [true, true, true];
  bool get _avcPassed => _avcPassedList.every((e) => e);

  @override
  Widget build(BuildContext context) {
    final double singleTextfieldWidth = (widget.width - 20.0) / 3 - 12;
    _avcPassedList[0] = widget.examer(widget.controllers[0].text);
    _avcPassedList[1] = widget.examer(widget.controllers[1].text);
    _avcPassedList[2] = widget.examer(widget.controllers[2].text);
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
                          color: _avcPassedList.every((e) => e) ? const Color(0xFFAED581) : const Color(0xFFEF5350),
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
                  SizedBox(
                    width: widget.width - 20,
                    height: 30,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.subtitle,
                        overflow: TextOverflow.ellipsis,
                        style: getStyle(
                          color: Colors.grey,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      XTextfield(
                        controller: widget.controllers[0],
                        width: singleTextfieldWidth,
                        textInputType: TextInputType.number,
                        onChanged: (v) {
                          bool res = widget.examer(v);
                          if (widget.controllers[0].text.isEmpty) {
                            res = true;
                          }
                          setState(() {
                            _avcPassedList[0] = res;
                          });
                          widget.onUpdateAVC(_avcPassed);
                        },
                        style: XTextfieldStyle(
                          hintText: 'X',
                          hintStyle: getStyle(
                            color: Colors.grey,
                            size: 18,
                          ),
                        ),
                      ),
                      XTextfield(
                        controller: widget.controllers[1],
                        width: singleTextfieldWidth,
                        textInputType: TextInputType.number,
                        onChanged: (v) {
                          bool res = widget.examer(v);
                          if (widget.controllers[1].text.isEmpty) {
                            res = true;
                          }
                          setState(() {
                            _avcPassedList[1] = res;
                          });
                          widget.onUpdateAVC(_avcPassed);
                        },
                        style: XTextfieldStyle(
                          hintText: 'Y',
                          hintStyle: getStyle(
                            color: Colors.grey,
                            size: 18,
                          ),
                        ),
                      ),
                      XTextfield(
                        controller: widget.controllers[2],
                        width: singleTextfieldWidth,
                        textInputType: TextInputType.number,
                        onChanged: (v) {
                          bool res = widget.examer(v);
                          if (widget.controllers[2].text.isEmpty) {
                            res = true;
                          }
                          setState(() {
                            _avcPassedList[2] = res;
                          });
                          widget.onUpdateAVC(_avcPassed);
                        },
                        style: XTextfieldStyle(
                          hintText: 'Z',
                          hintStyle: getStyle(
                            color: Colors.grey,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
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
