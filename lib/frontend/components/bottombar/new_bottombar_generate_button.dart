import 'package:colorify/frontend/scaffold/colors.dart';
import 'package:colorify/ui/basic/xbutton.dart';
import 'package:flutter/material.dart';

class NewBottombarGenerateButton extends StatelessWidget {
  final void Function() onTap;
  const NewBottombarGenerateButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return XButton(
      width: 70,
      height: 70,
      backgroundColor: MyTheme.tertiary,
      hoverColor: MyTheme.tertiary.withAlpha(200),
      splashColor: Colors.white.withAlpha(100),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(35),
        bottomLeft: Radius.circular(35),
        topRight: Radius.circular(6),
        bottomRight: Radius.circular(6),
      ),
      onTap: onTap,
      child: Center(
        child: Icon(Icons.play_arrow_rounded, color: Color(0xff5e000f), size: 36),
      ),
    );
  }
}
