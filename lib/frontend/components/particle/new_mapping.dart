import 'dart:async';

import 'package:colorify/backend/abstracts/rgbmapping.dart';
import 'package:colorify/backend/extensions/on_string.dart';
import 'package:colorify/frontend/scaffold/colors.dart';
import 'package:colorify/ui/basic/xbutton.dart';
import 'package:colorify/ui/basic/xframe.dart';
import 'package:colorify/ui/basic/xtextfield.dart';
import 'package:colorify/ui/hide/message_dialog.dart';
import 'package:colorify/ui/util/text_style.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class NewParticleMappingDialog extends StatefulWidget {
  final double width;
  final double height;
  final void Function(RGBMapping) onDone;
  final void Function() onCancel;
  const NewParticleMappingDialog({
    super.key,
    required this.width,
    required this.height,
    required this.onDone,
    required this.onCancel,
  });

  @override
  State<NewParticleMappingDialog> createState() => _NewParticleMappingDialogState();
}

class _NewParticleMappingDialogState extends State<NewParticleMappingDialog> {
  int _state = 0;

  final tecr = TextEditingController();
  final tecg = TextEditingController();
  final tecb = TextEditingController();
  final tecp = TextEditingController();

  void error(String title, String subtitle) {
    XFrame.message(
      title,
      subtitle: subtitle,
      style: MessageDialogStyle(
        width: 120,
        top: 100,
        right: 10,
        color: const Color(0xFF2d2a31),
        borderRadius: 2,
        titleStyle: getStyle(color: Colors.white, size: 18),
        subtitleStyle: getStyle(color: Colors.white, size: 14),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double singleFieldWidth = widget.width - 24;
    final double singleFieldHeight = (widget.height - 104) / 4 - 12;

    if (_state == 0) {
      Timer(
        const Duration(milliseconds: 10),
        () => setState(() {
          _state = 1;
        }),
      );
    }

    return AnimatedOpacity(
      opacity: _state == 1 ? 1 : 0,
      duration: const Duration(milliseconds: 240),
      curve: Curves.ease,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _state = 2;
          });
          Timer(const Duration(milliseconds: 240), widget.onCancel);
        },
        child: Container(
          width: 100.w,
          height: 100.h,
          color: Colors.black.withAlpha(80),
          child: GestureDetector(
            onTap: () {},
            child: Center(
              child: Container(
                width: widget.width,
                height: widget.height,
                decoration: BoxDecoration(
                  color: MyTheme.card,
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '映射参数 Mappin Args',
                      style: getStyle(color: Colors.white, size: 22),
                    ),
                    XTextfield(
                      width: singleFieldWidth,
                      height: singleFieldHeight,
                      controller: tecr,
                      textInputType: TextInputType.number,
                      style: XTextfieldStyle(
                        hintText: 'R',
                        hintStyle: getStyle(color: Colors.grey, size: 18),
                      ),
                    ),
                    XTextfield(
                      width: singleFieldWidth,
                      height: singleFieldHeight,
                      controller: tecg,
                      textInputType: TextInputType.number,
                      style: XTextfieldStyle(
                        hintText: 'G',
                        hintStyle: getStyle(color: Colors.grey, size: 18),
                      ),
                    ),
                    XTextfield(
                      width: singleFieldWidth,
                      height: singleFieldHeight,
                      controller: tecb,
                      textInputType: TextInputType.number,
                      style: XTextfieldStyle(
                        hintText: 'B',
                        hintStyle: getStyle(color: Colors.grey, size: 18),
                      ),
                    ),
                    XTextfield(
                      width: singleFieldWidth,
                      height: singleFieldHeight,
                      controller: tecp,
                      style: XTextfieldStyle(
                        hintText: '粒子 ID',
                        hintStyle: getStyle(color: Colors.grey, size: 18),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        XButton(
                          width: singleFieldWidth / 2 - 20,
                          height: singleFieldHeight - 16,
                          backgroundColor: MyTheme.tertiary,
                          hoverColor: MyTheme.tertiary.withAlpha(200),
                          splashColor: Colors.white.withAlpha(100),
                          borderRadius: BorderRadius.circular(30),
                          onTap: () {
                            setState(() {
                              _state = 2;
                            });
                            Timer(const Duration(milliseconds: 240), widget.onCancel);
                          },
                          child: Center(
                            child: Text(
                              '取消',
                              style: getStyle(color: Colors.black, size: 20),
                            ),
                          ),
                        ),
                        XButton(
                          width: singleFieldWidth / 2 - 20,
                          height: singleFieldHeight - 16,
                          backgroundColor: MyTheme.tertiary,
                          hoverColor: MyTheme.tertiary.withAlpha(200),
                          splashColor: Colors.white.withAlpha(100),
                          borderRadius: BorderRadius.circular(30),
                          onTap: () {
                            final r = tecr.text.toInt();
                            final g = tecg.text.toInt();
                            final b = tecb.text.toInt();
                            final pid = tecp.text;

                            if (r == null) {
                              error('不合法的 R', '非整型');
                              return;
                            }
                            if (g == null) {
                              error('不合法的 G', '非整型');
                              return;
                            }
                            if (b == null) {
                              error('不合法的 B', '非整型');
                              return;
                            }
                            if (pid.isEmpty) {
                              error('不合法的 PID', 'ID 为空');
                              return;
                            }

                            final mapping = RGBMapping(r: r, g: g, b: b, id: pid);

                            setState(() {
                              _state = 2;
                            });
                            Timer(const Duration(milliseconds: 240), () {
                              widget.onDone(mapping);
                            });
                          },
                          child: Center(
                            child: Text(
                              '确定',
                              style: getStyle(color: Colors.black, size: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
