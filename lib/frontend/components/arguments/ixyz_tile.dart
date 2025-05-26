import 'package:colorify/frontend/components/arguments/avc_state_indicator.dart';
import 'package:colorify/ui/basic/xtextfield.dart';
import 'package:colorify/ui/util/text_style.dart';
import 'package:flutter/material.dart';

class _IXYZTileTextfield extends StatelessWidget {
  final double width;
  final String hintText;
  final TextEditingController tec;
  final void Function(String v) onChanged;

  const _IXYZTileTextfield({
    required this.width,
    required this.hintText,
    required this.tec,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return XTextfield(
      controller: tec,
      width: width,
      textInputType: TextInputType.number,
      onChanged: onChanged,
      style: XTextfieldStyle(
        hintText: hintText,
        hintStyle: getStyle(
          color: Colors.grey,
          size: 18,
        ),
      ),
    );
  }
}

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

  void updateAVC(int index, String v) {
    bool res = widget.examer(v);
    if (widget.controllers[index].text.isEmpty) {
      res = true;
    }
    setState(() {
      _avcPassedList[index] = res;
    });
    widget.onUpdateAVC(_avcPassed);
  }

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
                    color: Colors.black.withAlpha(77),
                    blurRadius: 10,
                    spreadRadius: 1,
                    offset: const Offset(0, 4),
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
                      AvcStateIndicator(state: _avcPassed),
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
                      _IXYZTileTextfield(
                        width: singleTextfieldWidth,
                        hintText: 'X',
                        tec: widget.controllers[0],
                        onChanged: (v) => updateAVC(0, v),
                      ),
                      _IXYZTileTextfield(
                        width: singleTextfieldWidth,
                        hintText: 'Y',
                        tec: widget.controllers[1],
                        onChanged: (v) => updateAVC(1, v),
                      ),
                      _IXYZTileTextfield(
                        width: singleTextfieldWidth,
                        hintText: 'Z',
                        tec: widget.controllers[2],
                        onChanged: (v) => updateAVC(2, v),
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
