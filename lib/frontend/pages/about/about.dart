import 'package:colorify/frontend/components/about/acknowledgement_tile.dart';
import 'package:colorify/frontend/components/about/sponsor_qrcode.dart';
import 'package:colorify/ui/basic/xbutton.dart';
import 'package:colorify/ui/util/text_style.dart';
import 'package:flutter/material.dart';

class AboutTexts extends StatelessWidget {
  const AboutTexts({super.key});

  @override
  Widget build(BuildContext context) {
    final mqs = MediaQuery.of(context).size;

    Widget title(String text) {
      return Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2d2a31),
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 1,
              spreadRadius: 1,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Row(
          children: [
            Text(
              '# ',
              style: getStyle(
                size: 28,
                color: const Color(0xFFb9acc9),
              ),
            ),
            Text(
              text,
              style: getStyle(
                size: 22,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    Widget tile(String text, String? value) {
      return Container(
        width: mqs.width,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: getStyle(
                size: 22,
                color: Colors.white,
              ),
            ),
            Text(
              value ?? '',
              style: getStyle(
                size: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: mqs.width,
      height: mqs.height * 0.9,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          title('关于 About'),
          tile('应用', 'Colorify'),
          tile('版本', 'v6.0.3'),
          tile('开源协议', 'GPL-3.0'),
          const AcknowledgementTile(
            title: 'Comeix Alpha',
            subtitle: '作者',
            assetPath: 'assets/me.png',
            links: [
              'https://github.com/ComeixAlpha/Colorify6',
              'https://space.bilibili.com/1257718729',
            ],
          ),
          title('特别鸣谢 Acknowledgement'),
          const SizedBox(height: 20),
          const AcknowledgementTile(
            title: '静之秋恋 QuietFallHe',
            subtitle: '项目最初的的灵感来源',
            assetPath: 'assets/acknowledgement/quietfallhe.jpg',
            links: [
              'https://github.com/QuietFallHe',
              'https://space.bilibili.com/327352538',
            ],
          ),
          const AcknowledgementTile(
            title: '金羿ELS EillesWan',
            subtitle: '结构文件原理参考',
            assetPath: 'assets/acknowledgement/els.jpg',
            links: [
              'https://github.com/EillesWan',
              'https://gitee.com/EillesWan',
            ],
          ),
          const AcknowledgementTile(
            title: 'SlopeCraft & TokiNoBug',
            subtitle: '阶梯式原理参考',
            assetPath: 'assets/acknowledgement/tokinobug.jpg',
            links: [
              'https://github.com/ToKiNoBug',
              'https://slopecraft.readthedocs.io/',
            ],
          ),
          const AcknowledgementTile(
            title: 'Dislink Sforza',
            subtitle: 'Dithering 灵感来源',
            assetPath: 'assets/acknowledgement/dislink.jpg',
            links: [
              'https://github.com/Dislink',
              'https://space.bilibili.com/490775607',
            ],
          ),
          const AcknowledgementTile(
            title: 'DeltaRD',
            subtitle: 'Dithering 灵感来源',
            assetPath: 'assets/acknowledgement/deltard.jpg',
          ),
          const AcknowledgementTile(
            title: '雪璃 Glaze',
            subtitle: '测试人员',
            assetPath: 'assets/acknowledgement/glaze.jpg',
          ),
          title('赞助 Sponsor'),
          const SizedBox(height: 20),
          const SponsorQrcode(),
          const SizedBox(height: 20),
          const AcknowledgementTile(
            title: '核能蜥蜴',
            subtitle: 'Feb 25th 2024',
            assetPath: 'assets/sponsors/nuclear.png',
          ),
          const AcknowledgementTile(
            title: '灰常的优秀',
            subtitle: 'Oct 12th 2024',
            assetPath: 'assets/sponsors/hcdyx.jpg',
          ),
          const SizedBox(height: 200),
        ],
      ),
    );
  }
}

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    final mqs = MediaQuery.of(context).size;

    final tp = TextPainter(
      text: TextSpan(
        text: 'Documents',
        style: getStyle(
          color: Colors.white,
          size: 26,
          weight: FontWeight.w300,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    return Container(
      width: mqs.width,
      height: mqs.height,
      color: const Color(0xFF26232a),
      child: Column(
        children: [
          Container(
            width: mqs.width,
            height: mqs.height * 0.1,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                XButton(
                  width: tp.height,
                  height: tp.height,
                  backgroundColor: Colors.transparent,
                  hoverColor: Colors.white.withOpacity(0.2),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  borderRadius: BorderRadius.circular(tp.height / 2),
                  child: const Center(
                    child: Icon(
                      Icons.navigate_before,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  'Documents',
                  style: getStyle(
                    color: Colors.white,
                    size: 26,
                    weight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
          const AboutTexts(),
        ],
      ),
    );
  }
}
