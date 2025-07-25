import 'package:colorify/backend/extensions/on_string.dart';
import 'package:colorify/backend/providers/block.prov.dart';
import 'package:colorify/frontend/components/arguments/advanced_alert.dart';
import 'package:colorify/frontend/components/arguments/icheckbox_tile.dart';
import 'package:colorify/frontend/components/arguments/ipackageinfo_tile.dart';
import 'package:colorify/frontend/components/arguments/iselection_tile.dart';
import 'package:colorify/frontend/components/arguments/isize_tile.dart';
import 'package:colorify/frontend/components/arguments/istring_tile.dart';
import 'package:colorify/frontend/components/arguments/ixyz_tile.dart';
import 'package:colorify/ui/util/text_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final btecresizew = TextEditingController();
final btecresizeh = TextEditingController();
final btecpkname = TextEditingController();
final btecpkauth = TextEditingController();
final btecpkdesc = TextEditingController();
final btecflattn = TextEditingController();
final btecbox = TextEditingController();
final btecboy = TextEditingController();
final btecboz = TextEditingController();
final btecstaircasegap = TextEditingController();
final btecfscoe = TextEditingController();
final btecwscommanddelay = TextEditingController();

class BlockArguments extends StatefulWidget {
  final double width;
  final double height;
  const BlockArguments({super.key, required this.width, required this.height});

  @override
  State<BlockArguments> createState() => _BlockArgumentsState();
}

class _BlockArgumentsState extends State<BlockArguments> {
  @override
  Widget build(BuildContext context) {
    final blockprov = context.watch<Blockprov>();
    blockprov.refreshPalette();
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          const SizedBox(height: 20),
          ISizeTie(
            width: widget.width - 40,
            height: 140,
            title: '裁剪',
            subtitle: '裁剪到指定尺寸，只填一项锁定长宽比',
            controllers: [btecresizew, btecresizeh],
            examer: (v) {
              if (v.isEmpty) {
                return true;
              }
              final parsed = v.toInt();
              if (parsed == null) {
                return false;
              }
              if (parsed < 1) {
                return false;
              }
              return true;
            },
            onUpdateAVC: (v) {
              blockprov.updateAVC('resize', v);
            },
          ),
          ISelectionTile(
            title: '裁剪插值法',
            subtitle: 'Resize 的插值函数',
            width: widget.width - 40,
            height: 140,
            initValue: blockprov.interpolation,
            candidates: const ['Nearest', 'Cubic', 'Linear', 'Average'],
            onSelect: (v) {
              blockprov.interpolation = v;
            },
          ),
          ISelectionTile(
            title: '平面',
            subtitle: '像素画所在平面，Y 为高度轴',
            width: widget.width - 40,
            height: 140,
            initValue: blockprov.plane,
            candidates: const ['xOy', 'xOz', 'yOz'],
            onSelect: (v) {
              blockprov.plane = v;
            },
          ),
          ISelectionTile(
            title: '色差公式',
            subtitle: '计算色差的公式',
            width: widget.width - 40,
            height: 140,
            initValue: blockprov.rgb,
            candidates: const ['RGB(Manhattan)', 'RGB+'],
            onSelect: (v) {
              blockprov.rgb = v;
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
              blockprov.refreshPalette();
            },
          ),
          ICheckBoxTile(
            value: blockprov.dithering,
            title: '颜色抖动',
            subtitle: '使用 Floyd-Steinberg 算法处理图像',
            width: widget.width - 40,
            onCheck: (v) {
              blockprov.dithering = v;
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
          IStringTile(
            title: '版本-扁平化',
            subtitle: '通过您的游戏版本来影响部分方块 ID 扁平化',
            avcState: blockprov.avcWhere('flattening'),
            hintText: '1.20.80',
            hintStyle: getStyle(color: Colors.grey, size: 18),
            width: widget.width - 40,
            height: 140,
            controller: btecflattn,
            inputType: TextInputType.number,
            examer: (v) {
              return RegExp(r'\d+\.\d+(\.\d+)?').hasMatch(v);
            },
            onUpdateAVC: (v) {
              Provider.of<Blockprov>(context, listen: false).updateAVC('flattening', v);
            },
          ),
          IXYZTile(
            title: '基础偏移',
            subtitle: '从玩家坐标偏移基准点以防止被方块挤压',
            width: widget.width - 40,
            height: 150,
            controllers: [btecbox, btecboy, btecboz],
            examer: (v) {
              if (v.isEmpty) {
                return true;
              }
              if (v.toInt() != null) {
                return true;
              } else {
                return false;
              }
            },
            onUpdateAVC: (v) {
              Provider.of<Blockprov>(context, listen: false).updateAVC('basicOffset', v);
            },
          ),
          AdvancedAlert(width: widget.width - 40),
          IStringTile(
            title: '阶梯式竖向间隔',
            subtitle: 'JE 通常为 1 但在 BE 会出现马赛克',
            avcState: blockprov.avcWhere('staircasegap'),
            hintText: '2',
            hintStyle: getStyle(color: Colors.grey, size: 18),
            width: widget.width - 40,
            height: 140,
            controller: btecstaircasegap,
            inputType: TextInputType.number,
            examer: (v) {
              if (v.isEmpty) {
                return true;
              }
              final toint = v.toInt();
              if (toint == null) {
                return false;
              }
              if (toint < 1) {
                return false;
              }
              return true;
            },
            onUpdateAVC: (v) {
              blockprov.updateAVC('staircasegap', v);
            },
          ),
          IStringTile(
            title: 'Floyd-Steinberg 系数',
            subtitle: '控制颜色抖动，可以微调来改变抖动效果',
            avcState: blockprov.avcWhere('fscoe'),
            hintText: '16',
            hintStyle: getStyle(color: Colors.grey, size: 18),
            width: widget.width - 40,
            height: 140,
            controller: btecfscoe,
            inputType: TextInputType.number,
            examer: (v) {
              if (v.isEmpty) {
                return true;
              }
              if (v.toDouble() == null) {
                return false;
              }
              if (v.toDouble() == 0) {
                return false;
              }
              return true;
            },
            onUpdateAVC: (v) {
              blockprov.updateAVC('fscoe', v);
            },
          ),
          IStringTile(
            title: 'WebSocket 通信间隔',
            subtitle: '发送命令的间隔，太低会导致堵塞。单位 ms',
            avcState: blockprov.avcWhere('wsgap'),
            hintText: '10',
            hintStyle: getStyle(color: Colors.grey, size: 18),
            width: widget.width - 40,
            height: 140,
            controller: btecwscommanddelay,
            inputType: TextInputType.number,
            examer: (v) {
              if (v.isEmpty) {
                return true;
              }
              final toint = v.toInt();
              if (toint == null) {
                return false;
              }
              if (toint < 1) {
                return false;
              }
              return true;
            },
            onUpdateAVC: (v) {
              blockprov.updateAVC('wsgap', v);
            },
          ),
          const SizedBox(height: 400),
        ],
      ),
    );
  }
}
