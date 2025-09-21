import 'package:colorify/backend/providers/page.prov.dart';
import 'package:colorify/ui/util/text_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewBottombarPageButton extends StatefulWidget {
  final int index;
  final IconData icon;
  final String label;
  const NewBottombarPageButton({
    super.key,
    required this.index,
    required this.icon,
    required this.label,
  });

  @override
  State<NewBottombarPageButton> createState() => _NewBottombarPageButtonState();
}

class _NewBottombarPageButtonState extends State<NewBottombarPageButton> {
  bool _previousSelectedState = false;
  int _onSelectScaleAnimationStateIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pageprov = context.watch<Pageprov>();
    final isSelected = pageprov.page == widget.index;

    if (!isSelected && _previousSelectedState) {
      setState(() {
        _previousSelectedState = false;
      });
    }

    if (!_previousSelectedState && isSelected) {
      setState(() {
        _onSelectScaleAnimationStateIndex = 1;
        _previousSelectedState = true;
      });
    }

    if (_previousSelectedState && _onSelectScaleAnimationStateIndex == 1) {
      Future.delayed(const Duration(milliseconds: 240), () {
        if (mounted) {
          setState(() {
            _onSelectScaleAnimationStateIndex = 0;
          });
        }
      });
    }

    return GestureDetector(
      onTap: () {
        pageprov.update(widget.index);
      },
      child: AnimatedScale(
        scale: _onSelectScaleAnimationStateIndex == 1 ? 1.04 : 1.0,
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeInOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeInOut,
          width: isSelected ? 150 : 70,
          height: 70,
          decoration: BoxDecoration(
            color: const Color(0xff290a36),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(widget.icon, color: const Color(0xfff0bffa), size: 28),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 240),
                  curve: Curves.easeInOut,
                  width: isSelected ? 70 : 0,
                  height: 30,
                  margin: EdgeInsets.only(left: isSelected ? 12 : 0),
                  child: Center(
                    child: Baseline(
                      baseline: 21,
                      baselineType: TextBaseline.alphabetic,
                      child: Text(
                        widget.label,
                        overflow: TextOverflow.clip,
                        maxLines: 1,
                        style: getStyle(size: 18, color: const Color(0xfff0bffa)),
                      ),
                    ),
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
