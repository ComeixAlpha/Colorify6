import 'package:colorify/ui/util/text_style.dart';
import 'package:flutter/material.dart';

class AdvancedAlert extends StatelessWidget {
  final double width;
  const AdvancedAlert({
    super.key,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UnconstrainedBox(
          child: Container(
            width: width,
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '高级参数 Advanced',
                  style: getStyle(
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                SizedBox(
                  width: width - 40,
                  child: Text(
                    '如果您不知道这些参数该填多少则请勿填写',
                    overflow: TextOverflow.ellipsis,
                    style: getStyle(
                      color: Colors.grey,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
