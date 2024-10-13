import 'package:auto_size_text/auto_size_text.dart';
import 'package:colorify/ui/util/text_style.dart';
import 'package:flutter/material.dart';

class SponsorQrcode extends StatefulWidget {
  const SponsorQrcode({super.key});

  @override
  State<SponsorQrcode> createState() => _SponsorQrcodeState();
}

class _SponsorQrcodeState extends State<SponsorQrcode> {
  @override
  Widget build(BuildContext context) {
    final mqs = MediaQuery.of(context).size;
    return Opacity(
      opacity: 0.8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: mqs.width * 0.5,
            height: mqs.width * 0.5,
            child: CircleAvatar(
              radius: mqs.width * 0.5,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.asset('assets/sponsor.jpg'),
              ),
            ),
          ),
          Container(
            width: mqs.width * 0.5 - 16,
            height: mqs.width * 0.5,
            padding: const EdgeInsets.only(left: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sponsor Colorify',
                  overflow: TextOverflow.ellipsis,
                  style: getStyle(
                    size: 20,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'If You Like',
                  overflow: TextOverflow.ellipsis,
                  style: getStyle(
                    size: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '如果你觉得好用的话',
                  style: getStyle(
                    size: 16,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '可以考虑赞助一下哦',
                  style: getStyle(
                    size: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '留下备注，您会在下个版本出现在下方的赞助列表里',
                  style: getStyle(
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
