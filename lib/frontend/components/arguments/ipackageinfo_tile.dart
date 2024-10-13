import 'package:colorify/ui/basic/xtextfield.dart';
import 'package:colorify/ui/util/text_style.dart';
import 'package:flutter/material.dart';

class IPackageInfoTile extends StatefulWidget {
  final double width;
  final double height;
  final String title;
  final List<TextEditingController> controllers;
  const IPackageInfoTile({
    super.key,
    required this.width,
    required this.height,
    required this.title,
    required this.controllers,
  });

  @override
  State<IPackageInfoTile> createState() => _IPackageInfoTileState();
}

class _IPackageInfoTileState extends State<IPackageInfoTile> {
  @override
  Widget build(BuildContext context) {
    final double singleTextfieldWidth = widget.width - 20.0;
    final double singleTextfieldHeight = (widget.height - 22.0) / 3 - 12;
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
                          color: const Color(0xFFAED581),
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      XTextfield(
                        controller: widget.controllers[0],
                        width: singleTextfieldWidth,
                        height: singleTextfieldHeight,
                        style: XTextfieldStyle(
                          hintText: '包名',
                          hintStyle: getStyle(
                            color: Colors.grey,
                            size: 18,
                          ),
                        ),
                      ),
                      XTextfield(
                        controller: widget.controllers[1],
                        width: singleTextfieldWidth,
                        height: singleTextfieldHeight,
                        style: XTextfieldStyle(
                          hintText: '作者',
                          hintStyle: getStyle(
                            color: Colors.grey,
                            size: 18,
                          ),
                        ),
                      ),
                      XTextfield(
                        controller: widget.controllers[2],
                        width: singleTextfieldWidth,
                        height: singleTextfieldHeight,
                        style: XTextfieldStyle(
                          hintText: '描述',
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
