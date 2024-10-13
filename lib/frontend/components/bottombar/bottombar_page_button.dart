import 'package:colorify/backend/providers/page.prov.dart';
import 'package:colorify/frontend/components/bottombar/bottombar_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottombarPageButton extends StatefulWidget {
  final int index;
  final IconData icon;
  const BottombarPageButton({
    super.key,
    required this.index,
    required this.icon,
  });

  @override
  State<BottombarPageButton> createState() => _BottombarPageButtonState();
}

class _BottombarPageButtonState extends State<BottombarPageButton> {
  @override
  Widget build(BuildContext context) {
    final pageprov = context.watch<Pageprov>();
    final isSelected = pageprov.page == widget.index;
    return Stack(
      alignment: Alignment.center,
      children: [
        BottombarButton(
          icon: widget.icon,
          hoverColor: Colors.white.withOpacity(0.1),
          splashColor: Colors.white.withOpacity(0.1),
          onTap: () {
            pageprov.update(widget.index);
          },
        ),
        Positioned(
          bottom: 10,
          child: AnimatedOpacity(
            opacity: isSelected ? 1 : 0,
            duration: const Duration(milliseconds: 240),
            curve: Curves.ease,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 240),
              curve: Curves.ease,
              width: isSelected ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: const Color(0xFF736b7d),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
