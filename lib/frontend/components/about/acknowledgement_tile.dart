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
                  const SizedBox(width: 4),
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
                        child: SizedBox(
                          width: w - 4,
                          child: Text(
                            link,
                            overflow: TextOverflow.ellipsis,
                            style: getStyle(
                              color: const Color(0xFFC5C4DD).withOpacity(0.3),
                              fontStyle: FontStyle.italic,
                              decoration: TextDecoration.underline,
                              size: 16,
                            ),
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
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF454559),
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
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
                          overflow: TextOverflow.ellipsis,
                          style: getStyle(
                            color: const Color(0xFFE2E0F9),
                            size: 22,
                          ),
                        ),
                        Text(
                          widget.subtitle,
                          overflow: TextOverflow.ellipsis,
                          style: getStyle(
                            color: const Color(0xFFE2E0F9),
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              LayoutBuilder(
                builder: (_, __) {
                  if (widget.links == null) {
                    return const SizedBox();
                  } else {
                    return Column(
                      children: [
                        const SizedBox(height: 8),
                        ..._buildLink(mqs.width - 40, 22, widget.links ?? []),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
