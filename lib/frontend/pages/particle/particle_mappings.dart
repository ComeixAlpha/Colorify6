import 'package:auto_size_text/auto_size_text.dart';
import 'package:colorify/backend/providers/particle.prov.dart';
import 'package:colorify/frontend/components/particle/new_mapping.dart';
import 'package:colorify/frontend/components/rgbmapping_tile.dart';
import 'package:colorify/ui/basic/xframe.dart';
import 'package:colorify/ui/basic/xbutton.dart';
import 'package:colorify/ui/util/text_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RGBMapping {
  int r;
  int g;
  int b;
  String id;
  RGBMapping({
    required this.r,
    required this.g,
    required this.b,
    required this.id,
  });
}

class ParticleMappings extends StatefulWidget {
  final double width;
  final double height;
  const ParticleMappings({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  State<ParticleMappings> createState() => _ParticleMappingsState();
}

class _ParticleMappingsState extends State<ParticleMappings> {
  final List<RGBMapping> _mappings = [
    RGBMapping(r: 0, g: 0, b: 0, id: 'colorify:endrod'),
  ];

  OverlayEntry? _overlayEntry;

  XButton _newMappingButton() {
    return XButton(
      width: 140,
      height: 50,
      backgroundColor: const Color(0xFF2d2a31),
      hoverColor: const Color(0xFF2d2a31),
      onTap: () {
        _overlayEntry = OverlayEntry(
          builder: (ctx) {
            final Size mqs = MediaQuery.of(context).size;
            final double w = mqs.width * 0.8;
            final double h = mqs.height * 0.44;
            return Positioned(
              top: mqs.height / 2 - h / 2 - 40,
              left: mqs.width / 2 - w / 2,
              child: NewMapping(
                width: w,
                height: h,
                onDone: (v) {
                  setState(() {
                    _mappings.add(v);
                  });
                  Provider.of<Particleprov>(context, listen: false).setMappings(_mappings);
                  _overlayEntry?.remove();
                },
                onCancel: () => _overlayEntry?.remove(),
              ),
            );
          },
        );
        XFrame.insert(_overlayEntry!);
      },
      padding: const EdgeInsets.all(12),
      child: Center(
        child: AutoSizeText(
          '新建映射',
          style: getStyle(
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_mappings.isEmpty) {
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '还没有映射?',
              style: getStyle(
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 20),
            _newMappingButton(),
          ],
        ),
      );
    } else {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: ListView.builder(
          itemCount: _mappings.length + 1,
          padding: const EdgeInsets.all(0),
          itemBuilder: (ctx, i) {
            if (i == _mappings.length) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _newMappingButton(),
                ],
              );
            }
            return RGBMappingTile(
              width: widget.width,
              mapping: _mappings[i],
              onDelete: () {
                setState(() {
                  _mappings.removeAt(i);
                  Provider.of<Particleprov>(context, listen: false).setMappings(_mappings);
                });
              },
            );
          },
        ),
      );
    }
  }
}
