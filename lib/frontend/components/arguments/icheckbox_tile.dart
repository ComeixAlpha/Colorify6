import 'package:colorify/ui/util/text_style.dart';
import 'package:flutter/material.dart';

class ICheckBoxTile extends StatefulWidget {
  final bool value;
  final String title;
  final String subtitle;
  final double width;
  final double? height;
  final void Function(bool) onCheck;
  const ICheckBoxTile({
    super.key,
    required this.value,
    required this.title,
    required this.subtitle,
    required this.width,
    this.height,
    required this.onCheck,
  });

  @override
  State<ICheckBoxTile> createState() => _ICheckBoxTileState();
}

class _ICheckBoxTileState extends State<ICheckBoxTile> {
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedContainer(
                            curve: Curves.ease,
                            duration: const Duration(
                              milliseconds: 240,
                            ),
                            width: 10,
                            height: 10,
                            margin: const EdgeInsets.only(top: 10, right: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFAED581),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          // const SizedBox(width: 10),
                          Column(
                            children: [
                              SizedBox(
                                width: widget.width - 80,
                                child: Text(
                                  widget.title,
                                  overflow: TextOverflow.ellipsis,
                                  style: getStyle(
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: widget.width - 80,
                                child: Text(
                                  widget.subtitle,
                                  overflow: TextOverflow.ellipsis,
                                  style: getStyle(
                                    color: Colors.grey,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 30,
                        height: 30,
                        child: Transform.scale(
                          scale: 1.2,
                          child: Checkbox(
                            value: widget.value,
                            activeColor: const Color(0xFFAED581),
                            tristate: false,
                            onChanged: (v) => widget.onCheck(v!),
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
