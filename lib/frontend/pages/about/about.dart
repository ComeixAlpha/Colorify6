import 'package:colorify/frontend/components/about/acknowledgement_tile.dart';
import 'package:colorify/frontend/components/about/sponsor_qrcode.dart';
import 'package:colorify/ui/basic/xbutton.dart';
import 'package:colorify/ui/util/text_style.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutTexts extends StatelessWidget {
  const AboutTexts({super.key});

  @override
  Widget build(BuildContext context) {
    Widget title(String text) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Row(
          children: [
            Text('# ', style: getStyle(size: 28, color: const Color(0xFFb9acc9))),
            Text(text, style: getStyle(size: 22, color: Colors.white)),
          ],
        ),
      );
    }

    Widget tile(String text, String? value) {
      return Container(
        width: 100.w,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text, style: getStyle(size: 18, color: Colors.white)),
            Text(value ?? '', style: getStyle(size: 16, color: Colors.white)),
          ],
        ),
      );
    }

    Widget link(String text, String url) {
      return Container(
        width: 100.w,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text, style: getStyle(size: 18, color: Colors.white)),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () async {
                  final urlp = Uri.parse(url);
                  if (await canLaunchUrl(urlp)) {
                    launchUrl(urlp);
                  } else {
                    throw Exception();
                  }
                },
                child: Text(
                  url,
                  style: getStyle(
                    color: const Color(0xFFC5C4DD),
                    fontStyle: FontStyle.italic,
                    decoration: TextDecoration.underline,
                    size: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: 100.w,
      height: 100.h * 0.9,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          title('关于 Colorify'),
          tile('版本', 'v6.1.4'),
          tile('开源协议', 'GPL-3.0'),
          link('文档/教程', 'https://comeixalpha.github.io'),
          const SizedBox(height: 10),
          const AcknowledgementTile(
            title: 'Comeix Alpha',
            subtitle: '作者',
            assetPath: 'assets/me.png',
            links: [
              'https://github.com/ComeixAlpha/Colorify6',
              'https://space.bilibili.com/1257718729',
            ],
          ),
          title('特别鸣谢（按时间顺序）'),
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
            links: ['https://github.com/EillesWan', 'https://gitee.com/EillesWan'],
          ),
          const AcknowledgementTile(
            title: 'SlopeCraft & TokiNoBug',
            subtitle: '阶梯式原理参考',
            assetPath: 'assets/acknowledgement/tokinobug.jpg',
            links: ['https://github.com/ToKiNoBug', 'https://slopecraft.readthedocs.io/'],
          ),
          const AcknowledgementTile(
            title: 'Dislink Sforza',
            subtitle: 'Dithering 灵感来源',
            assetPath: 'assets/acknowledgement/dislink.jpg',
            links: ['https://github.com/Dislink', 'https://space.bilibili.com/490775607'],
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
          const AcknowledgementTile(
            title: 'Wn1027',
            subtitle: '阶梯式高度压缩思路参考',
            assetPath: 'assets/acknowledgement/wn1027.jpg',
            links: [
              'https://www.minebbs.com/resources/authors/10_27.10809/',
              'https://gitee.com/wn1027',
            ],
          ),
          const AcknowledgementTile(
            title: 'Happy2018new',
            subtitle: '地图基色表提供',
            assetPath: 'assets/acknowledgement/happy.jpg',
            links: ['https://github.com/Happy2018new'],
          ),
          title('赞助 Sponsor（按时间顺序）'),
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
          // const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    final tp = TextPainter(
      text: TextSpan(
        text: 'Documents',
        style: getStyle(color: Colors.white, size: 26, weight: FontWeight.w300),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    return Container(
      width: 100.w,
      height: 100.h,
      color: const Color(0xFF26232a),
      child: Column(
        children: [
          Container(
            width: 100.w,
            height: 100.h * 0.1,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                XButton(
                  width: tp.height,
                  height: tp.height,
                  backgroundColor: Colors.transparent,
                  hoverColor: Colors.white.withAlpha(51),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  borderRadius: BorderRadius.circular(tp.height / 2),
                  child: const Center(
                    child: Icon(Icons.navigate_before, size: 30, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Documents',
                  style: getStyle(color: Colors.white, size: 28, weight: FontWeight.w300),
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
