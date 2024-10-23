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
    return Container(
      width: mqs.width,
      height: mqs.height,
      color: Colors.black.withOpacity(0.3),
      child: Center(
        child: UnconstrainedBox(
          child: Container(
            width: mqs.width * 0.7,
            decoration: BoxDecoration(
              color: const Color(0xFF2d2a31),
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '需要确认 Comfirm',
                      overflow: TextOverflow.ellipsis,
                      style: getStyle(
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      content,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: getStyle(
                        color: Colors.white.withOpacity(0.6),
                        size: 16,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      XButton(
                        width: mqs.width * 0.7 * 0.3,
                        height: 50,
                        onTap: () => onChoose(false),
                        backgroundColor: Colors.transparent,
                        hoverColor: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(24),
                        child: Center(
                          child: AutoSizeText(
                            '取消',
                            style: getStyle(
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      XButton(
                        width: mqs.width * 0.9 * 0.25,
                        height: 50,
                        onTap: () => onChoose(true),
                        backgroundColor: Colors.transparent,
                        hoverColor: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(24),
                        child: Center(
                          child: AutoSizeText(
                            '确定',
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
      ),
    );
  }
}
