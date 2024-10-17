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
  @override
  Widget build(BuildContext context) {
    final blockprov = context.watch<Blockprov>();
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
            subtitle: '对原图的采样率，取值范围为(0, 1]',
            hintText: '自动',
            hintStyle: getStyle(color: Colors.grey, size: 18),
            width: widget.width - 40,
            height: 140,
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
              Provider.of<Blockprov>(context, listen: false).avc = v;
            },
          ),
          ISelectionTile(
            title: '平面',
            subtitle: '像素画所在平面，Y 为高度轴',
            width: widget.width - 40,
            height: 140,
            candidates: const ['xOy', 'xOz', 'yOz'],
            onSelect: (v) {
              blockprov.plane = v;
            },
          ),
          ICheckBoxTile(
            value: blockprov.stairType,
            title: '阶梯式',
            subtitle: '生成阶梯式，面向 Y+ 的立体像素画',
            width: widget.width - 40,
            onCheck: (v) {
              blockprov.stairType = v;
              if (v) {
                blockprov.useStruct = false;
                blockprov.dithering = false;
                blockprov.carpetOnly = false;
                blockprov.refreshPalette();
              }
            },
          ),
          ICheckBoxTile(
            value: blockprov.useStruct,
            title: '使用结构',
            subtitle: '导出为 .mcstructure 格式文件',
            width: widget.width - 40,
            onCheck: (v) {
              blockprov.useStruct = v;
              if (v) {
                blockprov.stairType = false;
              }
              blockprov.refreshPalette();
            },
          ),
          ICheckBoxTile(
            value: blockprov.dithering,
            title: '颜色抖动',
            subtitle: '使用 Floyd-Steinberg 算法处理图像，小体积画不建议使用',
            width: widget.width - 40,
            onCheck: (v) {
              blockprov.dithering = v;
              if (v) {
                blockprov.stairType = false;
              }
              blockprov.refreshPalette();
            },
          ),
          ICheckBoxTile(
            value: blockprov.carpetOnly,
            title: '仅地毯',
            subtitle: '使材料全部为地毯',
            width: widget.width - 40,
            onCheck: (v) {
              blockprov.carpetOnly = v;
              if (v) {
                blockprov.stairType = false;
                blockprov.noGlasses = false;
                blockprov.noSands = false;
              }
              blockprov.refreshPalette();
            },
          ),
          ICheckBoxTile(
            value: blockprov.noGlasses,
            title: '去除玻璃',
            subtitle: '去除调色板中所有玻璃与玻璃板',
            width: widget.width - 40,
            onCheck: (v) {
              blockprov.noGlasses = v;
              blockprov.refreshPalette();
            },
          ),
          ICheckBoxTile(
            value: blockprov.noSands,
            title: '去除沙子与混凝土粉末',
            subtitle: '去除调色板中所有沙子与混凝土粉末',
            width: widget.width - 40,
            onCheck: (v) {
              blockprov.noSands = v;
              blockprov.refreshPalette();
            },
          ),
          IPackageInfoTile(
            title: '打包',
              subtitle: '打包为 .mcpack 并自动生成清单与图标',
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
