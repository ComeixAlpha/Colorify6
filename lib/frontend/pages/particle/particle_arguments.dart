import 'package:colorify/backend/extensions/on_string.dart';
import 'package:colorify/backend/providers/particle.prov.dart';
import 'package:colorify/frontend/components/arguments/ipackageinfo_tile.dart';
import 'package:colorify/frontend/components/arguments/iselection_tile.dart';
import 'package:colorify/frontend/components/arguments/istring_tile.dart';
import 'package:colorify/frontend/components/arguments/ixyz_tile.dart';
import 'package:colorify/ui/util/text_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final ptecSampling = TextEditingController();
final ptecHeight = TextEditingController();
final ptecrx = TextEditingController();
final ptecry = TextEditingController();
final ptecrz = TextEditingController();
final ptecpkname = TextEditingController();
final ptecpkauth = TextEditingController();
final ptecpkdesc = TextEditingController();

class ParticleArguments extends StatefulWidget {
  final double width;
  final double height;
  const ParticleArguments({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  State<ParticleArguments> createState() => _ParticleArgumentsState();
}

class _ParticleArgumentsState extends State<ParticleArguments> {
  final List<bool> _avc = List.generate(5, (i) => true);

  void notify() {
    Provider.of<Particleprov>(context, listen: false).updateAVCState(_avc.every((e) => e));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          ...[
            const SizedBox(height: 20),
            IStringTile(
              title: '采样率',
              hintText: 'Auto',
              hintStyle: getStyle(color: Colors.grey, size: 18),
              width: widget.width - 40,
              height: 110,
              controller: ptecSampling,
              inputType: TextInputType.number,
              examer: (v) {
                final parsed = v.toDouble();
                if (parsed == null) {
                  return false;
                } else if (parsed <= 0 || parsed > 1) {
                  return false;
                } else {
                  return true;
                }
              },
              onUpdateAVC: (v) {
                setState(() {
                  _avc[0] = v;
                  notify();
                });
              },
            ),
            IStringTile(
              title: '高度',
              hintText: 'Auto',
              hintStyle: getStyle(color: Colors.grey, size: 18),
              width: widget.width - 40,
              height: 110,
              controller: ptecHeight,
              inputType: TextInputType.number,
              examer: (v) {
                final parsed = v.toDouble();
                if (parsed == null) {
                  return false;
                } else if (parsed <= 0) {
                  return false;
                } else {
                  return true;
                }
              },
              onUpdateAVC: (v) {
                setState(() {
                  _avc[1] = v;
                  notify();
                });
              },
            ),
            ISelectionTile(
              title: '平面',
              width: widget.width - 40,
              height: 110,
              candidates: const ['xOy', 'xOz', 'yOz'],
              onSelect: (v) {
                Provider.of<Particleprov>(context, listen: false).setPlane(v);
              },
            ),
            ISelectionTile(
              title: '模式',
              width: widget.width - 40,
              height: 110,
              candidates: const ['Match', 'Dust'],
              onSelect: (v) {
                Provider.of<Particleprov>(context, listen: false).setMode(
                  v == 0 ? GenerateMode.match : GenerateMode.dust,
                );
              },
            ),
            IXYZTile(
              title: '旋转',
              width: widget.width - 40,
              height: 120,
              controllers: [ptecrx, ptecry, ptecrz],
              examer: (v) {
                if (v.toDouble() != null) {
                  return true;
                } else {
                  return false;
                }
              },
              onUpdateAVC: (v) {
                setState(() {
                  _avc[3] = v;
                  notify();
                });
              },
            ),
            IPackageInfoTile(
              title: '打包',
              width: widget.width - 40,
              height: 280,
              controllers: [ptecpkname, ptecpkauth, ptecpkdesc],
            ),
          ],
          const SizedBox(height: 400)
        ],
      ),
    );
  }
}
