import 'package:auto_size_text/auto_size_text.dart';
import 'package:colorify/backend/abstracts/rgbmapping.dart';
import 'package:colorify/backend/providers/particle.prov.dart';
import 'package:colorify/frontend/components/particle/new_mapping.dart';
import 'package:colorify/frontend/components/particle/rgbmapping_tile.dart';
import 'package:colorify/frontend/scaffold/colors.dart';
import 'package:colorify/ui/basic/xbutton.dart';
import 'package:colorify/ui/basic/xframe.dart';
import 'package:colorify/ui/util/text_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ParticleMappings extends StatefulWidget {
  final double width;
  final double height;
  const ParticleMappings({super.key, required this.width, required this.height});

  @override
  State<ParticleMappings> createState() => _ParticleMappingsState();
}

class _ParticleMappingsState extends State<ParticleMappings> {
  final List<RGBMapping> _mappings = [
    RGBMapping(r: 0, g: 0, b: 0, id: 'minecraft:endrod'),
  ];

  OverlayEntry? _overlayEntry;

  XButton _newMappingButton() {
    return XButton(
      width: 150,
      height: 60,
      backgroundColor: MyTheme.tertiary,
      hoverColor: MyTheme.tertiary.withAlpha(200),
      splashColor: Colors.white.withAlpha(100),
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        _overlayEntry = OverlayEntry(
          builder: (ctx) {
            final double w = 100.w * 0.8;
            final double h = 100.h * 0.44;
            return NewParticleMappingDialog(
              width: w,
              height: h,
              onDone: (v) {
                setState(() {
                  _mappings.add(v);
                });
                Provider.of<Particleprov>(
                  context,
                  listen: false,
                ).setMappings(_mappings);
                _overlayEntry?.remove();
              },
              onCancel: () => _overlayEntry?.remove(),
            );
          },
        );
        XFrame.insert(_overlayEntry!);
      },
      padding: const EdgeInsets.all(12),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(Icons.add, color: MyTheme.onTertiary, size: 28),
            SizedBox(width: 10),
            AutoSizeText('新建映射', style: getStyle(color: MyTheme.onTertiary, size: 20)),
          ],
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
            Text('还没有映射?', style: getStyle(color: Colors.white, size: 24)),
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
              return Column(
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [_newMappingButton()],
                  ),
                  const SizedBox(height: 100),
                ],
              );
            }

            if (i == 0) {
              return Column(
                children: [
                  const SizedBox(height: 20),
                  RGBMappingTile(
                    width: widget.width,
                    mapping: _mappings[i],
                    onDelete: () {
                      setState(() {
                        _mappings.removeAt(i);
                        Provider.of<Particleprov>(
                          context,
                          listen: false,
                        ).setMappings(_mappings);
                      });
                    },
                  ),
                ],
              );
            }

            return RGBMappingTile(
              width: widget.width,
              mapping: _mappings[i],
              onDelete: () {
                setState(() {
                  _mappings.removeAt(i);
                  Provider.of<Particleprov>(
                    context,
                    listen: false,
                  ).setMappings(_mappings);
                });
              },
            );
          },
        ),
      );
    }
  }
}
