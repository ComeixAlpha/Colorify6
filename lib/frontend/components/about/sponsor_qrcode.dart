import 'package:colorify/ui/util/text_style.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SponsorQrcode extends StatefulWidget {
  const SponsorQrcode({super.key});

  @override
  State<SponsorQrcode> createState() => _SponsorQrcodeState();
}

class _SponsorQrcodeState extends State<SponsorQrcode> {
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.w * 0.5,
            height: 100.w * 0.5,
            child: CircleAvatar(
              radius: 100.w * 0.5,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.asset('assets/sponsor.jpg'),
              ),
            ),
          ),
          Container(
            width: 100.w * 0.5 - 16,
            height: 100.w * 0.5,
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
