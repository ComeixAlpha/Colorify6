import 'package:colorify/backend/providers/page.prov.dart';
import 'package:colorify/backend/providers/socket.prov.dart';
import 'package:colorify/frontend/scaffold/colors.dart';
import 'package:colorify/ui/basic/xbutton.dart';
import 'package:colorify/ui/basic/xframe.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewBottombarWSButton extends StatelessWidget {
  final Future<void> Function() onRequestingParticleTask;
  final Future<void> Function() onRequestingBlockTask;
  const NewBottombarWSButton({
    super.key,
    required this.onRequestingParticleTask,
    required this.onRequestingBlockTask,
  });

  @override
  Widget build(BuildContext context) {
    return XButton(
      width: 70,
      height: 70,
      backgroundColor: MyTheme.tertiary,
      hoverColor: MyTheme.tertiary.withAlpha(200),
      splashColor: Colors.white.withAlpha(100),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(6),
        bottomLeft: Radius.circular(6),
        topRight: Radius.circular(35),
        bottomRight: Radius.circular(35),
      ),
      child: Center(
        child: Icon(Icons.sensors_rounded, color: Color(0xff5e000f), size: 36),
      ),
      onTap: () {
        final pageprov = Provider.of<Pageprov>(context, listen: false);
        final socketprov = Provider.of<Socketprov>(context, listen: false);
        if (socketprov.connected) {
          if (pageprov.page == 0) {
            XFrame.comfirm('要通过WS传输粒子画吗?', (v) async {
              if (v) {
                await onRequestingParticleTask();
              }
            });
          } else if (pageprov.page == 1) {
            XFrame.comfirm('要通过WS传输像素画吗?', (v) async {
              if (v) {
                await onRequestingBlockTask();
              }
            });
          }
        }
        pageprov.update(2);
      },
    );
  }
}
