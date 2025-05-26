import 'package:auto_size_text/auto_size_text.dart';
import 'package:colorify/ui/basic/xbutton.dart';
import 'package:colorify/ui/util/text_style.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class NoPermisson extends StatelessWidget {
  final void Function() onCallClose;
  const NoPermisson({
    super.key,
    required this.onCallClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 100.h,
      decoration: BoxDecoration(
        color: const Color(0xFF2d2a31),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 40, color: Colors.red),
            Text(
              'FATAL ERROR',
              style: getStyle(
                color: Colors.white,
                size: 40,
              ),
            ),
            Text(
              '严重错误',
              style: getStyle(
                color: Colors.white,
                size: 40,
              ),
            ),
            Text(
              '由于您拒绝授予外部存储读写权限',
              style: getStyle(
                color: Colors.white,
                size: 24,
              ),
            ),
            Text(
              '或是',
              style: getStyle(
                color: Colors.white,
                size: 24,
              ),
            ),
            Text(
              '权限申请由于异常未触发',
              style: getStyle(
                color: Colors.white,
                size: 24,
              ),
            ),
            Text(
              '此应用未拥有运行所需的必要权限',
              style: getStyle(
                color: Colors.white,
                size: 24,
              ),
            ),
            Text(
              '请您前往设置手动授予本应用',
              style: getStyle(
                color: Colors.white,
                size: 24,
              ),
            ),
            Text(
              '**外部存储读写权限**',
              style: getStyle(
                color: Colors.white,
                size: 24,
              ),
            ),
            Text(
              '并重启此应用来消除此弹窗',
              style: getStyle(
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '如果您确保您已经开启了权限还是遇到此窗口',
              style: getStyle(
                color: Colors.grey,
                size: 20,
              ),
            ),
            Text(
              '或是您在设置里找不到对应的权限可以开启',
              style: getStyle(
                color: Colors.grey,
                size: 20,
              ),
            ),
            Text(
              '请您联系开发者 2245638853@qq.com 提供以下信息',
              style: getStyle(
                color: Colors.grey,
                size: 20,
              ),
            ),
            Text(
              '您的设备型号',
              style: getStyle(
                color: Colors.grey,
                size: 20,
              ),
            ),
            Text(
              '您的OS(系统)类型及版本',
              style: getStyle(
                color: Colors.grey,
                size: 20,
              ),
            ),
            Text(
              '您的Android版本',
              style: getStyle(
                color: Colors.grey,
                size: 20,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '如果你确定已经给予权限，请按下面的按钮',
              style: getStyle(
                color: Colors.grey,
                size: 20,
              ),
            ),
            XButton(
              width: 140,
              height: 50,
              backgroundColor: const Color(0xFF2d2a31),
              hoverColor: const Color(0xFF2d2a31),
              padding: const EdgeInsetsDirectional.all(12),
              onTap: onCallClose,
              child: Center(
                child: AutoSizeText(
                  'Ensure',
                  style: getStyle(
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
