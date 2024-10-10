import 'package:auto_size_text/auto_size_text.dart';
import 'package:colorify/ui/basic/xbutton.dart';
import 'package:colorify/ui/util/text_style.dart';
import 'package:flutter/material.dart';

class ComfirmDialog extends StatelessWidget {
  final String content;
  final void Function(bool) onChoose;
  const ComfirmDialog({
    super.key,
    required this.content,
    required this.onChoose,
  });

  @override
  Widget build(BuildContext context) {
    final mqs = MediaQuery.of(context).size;
    final h = mqs.height * 0.2;
    final ch = (h - 24) / 3;
    return Container(
      width: mqs.width,
      height: mqs.height,
      color: Colors.black.withOpacity(0.3),
      child: Center(
        child: Container(
          width: mqs.width * 0.7,
          height: h,
          decoration: BoxDecoration(
            color: const Color(0xFF2d2a31),
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: ch,
                child: Center(
                  child: Text(
                    'Need Comfirm',
                    style: getStyle(
                      color: Colors.grey,
                      size: 18,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: ch,
                child: Center(
                  child: Text(
                    content,
                    style: getStyle(
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: ch,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    XButton(
                      width: mqs.width * 0.7 * 0.3,
                      height: ch < 50 ? ch : 50,
                      onTap: () => onChoose(false),
                      backgroundColor: const Color(0xFF504a57),
                      hoverColor: const Color(0xFF2d2a31),
                      child: Center(
                        child: AutoSizeText(
                          'Cancel',
                          style: getStyle(
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                    XButton(
                      width: mqs.width * 0.9 * 0.25,
                      height: ch < 50 ? ch : 50,
                      onTap: () => onChoose(true),
                      backgroundColor: const Color(0xFF504a57),
                      hoverColor: const Color(0xFF2d2a31),
                      child: Center(
                        child: AutoSizeText(
                          'Comfirm',
                          style: getStyle(
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
