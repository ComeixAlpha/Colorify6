import 'package:colorify/backend/extensions/on_string.dart';
import 'package:colorify/backend/providers/block.prov.dart';
import 'package:colorify/frontend/components/arguments/icheckbox_tile.dart';
import 'package:colorify/frontend/components/arguments/ipackageinfo_tile.dart';
import 'package:colorify/frontend/components/arguments/iselection_tile.dart';
import 'package:colorify/frontend/components/arguments/istring_tile.dart';
import 'package:colorify/ui/util/text_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final btecSampling = TextEditingController();
final btecpkname = TextEditingController();
final btecpkauth = TextEditingController();
final btecpkdesc = TextEditingController();

class BlockArguments extends StatefulWidget {
  final double width;
  final double height;
  const BlockArguments({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  State<BlockArguments> createState() => _BlockArgumentsState();
}

class _BlockArgumentsState extends State<BlockArguments> {
  int _plane = 0;
  bool _stairType = false;
  bool _useStruct = false;
  bool _dithering = false;
  bool _noGlasses = false;
  bool _noSands = false;
  bool _carpetOnly = false;

  @override
  Widget build(BuildContext context) {
    Provider.of<Blockprov>(context, listen: false).updateAll(
      iplane: _plane,
      istairType: _stairType,
      iuseStruct: _useStruct,
      idithering: _dithering,
      inoGlasses: _noGlasses,
      inoSands: _noSands,
      icarpetOnly: _carpetOnly,
    );
    Provider.of<Blockprov>(context, listen: false).refreshPalette();
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          const SizedBox(height: 20),
          IStringTile(
            title: '采样率',
            hintText: '自动',
            hintStyle: getStyle(color: Colors.grey, size: 18),
            width: widget.width - 40,
            height: 110,
            controller: btecSampling,
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
              Provider.of<Blockprov>(context, listen: false).updateAVCState(v);
            },
          ),
          ISelectionTile(
            title: '平面',
            width: widget.width - 40,
            height: 110,
            candidates: const ['xOy', 'xOz', 'yOz'],
            onSelect: (v) {
              setState(() {
                _plane = v;
              });
            },
          ),
          ICheckBoxTile(
            value: _stairType,
            title: '阶梯式',
            width: widget.width - 40,
            onCheck: (v) {
              setState(() {
                _stairType = v;
                if (v) {
                  _useStruct = false;
                  _dithering = false;
                  _carpetOnly = false;
                }
              });
            },
          ),
          ICheckBoxTile(
            value: _useStruct,
            title: '使用结构',
            width: widget.width - 40,
            onCheck: (v) {
              setState(() {
                _useStruct = v;
                if (v) {
                  _stairType = false;
                }
              });
            },
          ),
          ICheckBoxTile(
            value: _dithering,
            title: '颜色抖动 (Floyd-Steinberg)',
            width: widget.width - 40,
            onCheck: (v) {
              setState(() {
                _dithering = v;
                if (v) {
                  _stairType = false;
                }
              });
            },
          ),
          ICheckBoxTile(
            value: _carpetOnly,
            title: '仅地毯',
            width: widget.width - 40,
            onCheck: (v) {
              setState(() {
                _carpetOnly = v;
                if (v) {
                  _stairType = false;
                  _noGlasses = true;
                  _noSands = true;
                }
              });
            },
          ),
          ICheckBoxTile(
            value: _noGlasses,
            title: '去除玻璃',
            width: widget.width - 40,
            onCheck: (v) {
              setState(() {
                _noGlasses = v;
              });
            },
          ),
          ICheckBoxTile(
            value: _noSands,
            title: '去除沙子与混凝土粉末',
            width: widget.width - 40,
            onCheck: (v) {
              setState(() {
                _noSands = v;
              });
            },
          ),
          IPackageInfoTile(
            title: '打包',
            width: widget.width - 40,
            height: 280,
            controllers: [btecpkname, btecpkauth, btecpkdesc],
          ),
          const SizedBox(height: 400),
        ],
      ),
    );
  }
}
