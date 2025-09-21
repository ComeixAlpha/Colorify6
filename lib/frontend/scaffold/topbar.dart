import 'package:colorify/frontend/pages/about/about.dart';
import 'package:colorify/frontend/scaffold/colors.dart';
import 'package:colorify/ui/basic/xbutton.dart';
import 'package:colorify/ui/util/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Topbar extends StatelessWidget {
  final double width;
  final double height;
  const Topbar({super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    final tp1 = TextPainter(
      text: TextSpan(
        text: 'Colorify',
        style: getStyle(
          color: Colors.white,
          size: 34,
          weight: FontWeight.w700,
          fontFamily: "Yellowtail",
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final tp2 = TextPainter(
      text: TextSpan(
        text: 'v6',
        style: getStyle(
          color: Colors.white.withAlpha(77),
          size: 30,
          weight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    return Container(
      width: width,
      height: height,
      color: MyTheme.background,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: tp1.width + 10,
                height: tp1.height,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Colorify',
                    overflow: TextOverflow.ellipsis,
                    style: getStyle(
                      color: MyTheme.onPrimary,
                      size: 32,
                      weight: FontWeight.w700,
                      fontFamily: "Yellowtail",
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: tp2.width + 10,
                height: tp2.height,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'v6',
                    overflow: TextOverflow.ellipsis,
                    style: getStyle(
                      // color: Colors.white.withAlpha(77),
                      color: MyTheme.onPrimary,
                      size: 30,
                      weight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          LayoutBuilder(
            builder: (_, __) {
              final restWidth = 100.w - 47 - tp1.width - tp2.width;
              if (restWidth >= tp1.height) {
                return XButton(
                  width: tp1.height,
                  height: tp1.height,
                  // backgroundColor: Colors.transparent,
                  backgroundColor: MyTheme.tertiary,
                  // hoverColor: Colors.white.withAlpha(51),
                  hoverColor: MyTheme.tertiary.withAlpha(200),
                  splashColor: Colors.white.withAlpha(100),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (BuildContext ctx) {
                          return const About();
                        },
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Center(
                    child: Icon(Icons.auto_stories_rounded, color: MyTheme.onTertiary),
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ],
      ),
    );
  }
}
