import 'package:colorify/ui/util/text_style.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AcknowledgementTile extends StatefulWidget {
  final String assetPath;
  final String title;
  final String subtitle;
  final List<String>? links;
  const AcknowledgementTile({
    super.key,
    required this.assetPath,
    required this.title,
    required this.subtitle,
    this.links,
  });

  @override
  State<AcknowledgementTile> createState() => _AcknowledgementTileState();
}

class _AcknowledgementTileState extends State<AcknowledgementTile> {
  List<Widget> _buildLink(double w, double h, List<String> links) {
    final List<Widget> widgets = [];
    for (String link in links) {
      widgets.add(
        Column(
          children: [
            const SizedBox(height: 10),
            SizedBox(
              width: w,
              height: h,
              child: Row(
                children: [
                  const SizedBox(width: 14),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () async {
                          final url = Uri.parse(link);
                          if (await canLaunchUrl(url)) {
                            launchUrl(url);
                          } else {
                            throw Exception();
                          }
                        },
                        child: Text(
                          link,
                          overflow: TextOverflow.ellipsis,
                          style: getStyle(
                            color: const Color(0xFFb9acc9),
                            fontStyle: FontStyle.italic,
                            decoration: TextDecoration.underline,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    final mqs = MediaQuery.of(context).size;
    final w = mqs.width / 6;
    return Column(
      children: [
        const SizedBox(height: 24),
        SizedBox(
          width: mqs.width - 16,
          height: mqs.width / 6,
          child: Row(
            children: [
              SizedBox(
                width: w,
                height: w,
                child: CircleAvatar(
                  radius: w,
                  backgroundColor: Colors.transparent,
                  child: ClipOval(
                    child: Image.asset(widget.assetPath),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: getStyle(
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  Text(
                    widget.subtitle,
                    style: getStyle(
                      color: Colors.grey,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        ..._buildLink(mqs.width - 16, 22, widget.links ?? []),
      ],
    );
  }
}
