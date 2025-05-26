import 'package:colorify/backend/providers/page.prov.dart';
import 'package:colorify/ui/basic/xbutton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageButton extends StatefulWidget {
  final int index;
  final IconData icon;
  const PageButton({
    super.key,
    required this.index,
    required this.icon,
  });

  @override
  State<PageButton> createState() => _PageButtonState();
}

class _PageButtonState extends State<PageButton> {
  @override
  Widget build(BuildContext context) {
    final pageprov = context.watch<Pageprov>();
    final isSelected = pageprov.page == widget.index;
    return AnimatedOpacity(
      opacity: isSelected ? 1 : 0.3,
      duration: const Duration(milliseconds: 240),
      child: XButton(
        width: 60,
        height: 60,
        borderRadius: BorderRadius.circular(30),
        backgroundColor: const Color(0xFF736b7d).withAlpha(isSelected ? 77 : 0),
        hoverColor: const Color(0xFF736b7d).withAlpha(isSelected ? 77 : 0),
        splashColor: Colors.transparent,
        duration: const Duration(milliseconds: 240),
        onTap: () {
          pageprov.update(widget.index);
        },
        child: Icon(
          widget.icon,
          color: Colors.white,
        ),
      ),
    );
  }
}
