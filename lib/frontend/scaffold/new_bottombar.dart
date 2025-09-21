import 'package:colorify/backend/abstracts/genblockargs.dart';
import 'package:colorify/backend/abstracts/genparticleargs.dart';
import 'package:colorify/backend/abstracts/isolate_data_pack.dart';
import 'package:colorify/backend/generators/generator.dart';
import 'package:colorify/backend/providers/block.prov.dart';
import 'package:colorify/backend/providers/page.prov.dart';
import 'package:colorify/backend/providers/particle.prov.dart';
import 'package:colorify/backend/providers/progress.prov.dart';
import 'package:colorify/backend/providers/socket.prov.dart';
import 'package:colorify/backend/utils/common/flie_picker.dart';
import 'package:colorify/backend/utils/common/path.dart';
import 'package:colorify/backend/utils/minecraft/identicon.dart';
import 'package:colorify/frontend/components/bottombar/new_bottombar_generate_button.dart';
import 'package:colorify/frontend/components/bottombar/new_bottombar_page_button.dart';
import 'package:colorify/frontend/components/bottombar/new_bottombar_ws_button.dart';
import 'package:colorify/frontend/components/processing/progress_indicator.dart';
import 'package:colorify/frontend/scaffold/bottombar.dart';
import 'package:colorify/ui/basic/xframe.dart';
import 'package:colorify/ui/hide/message_dialog.dart';
import 'package:colorify/ui/util/text_style.dart';
import 'package:flutter/material.dart' hide ProgressIndicator;
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class NewBottombar extends StatefulWidget {
  const NewBottombar({super.key});

  @override
  State<NewBottombar> createState() => _NewBottombarState();
}

class _NewBottombarState extends State<NewBottombar> {
  OverlayEntry? _overlayEntry;

  void _alertAVCError() {
    XFrame.message(
      '参数错误',
      subtitle: '参数合法性检查未通过',
      style: MessageDialogStyle(
        width: 120,
        top: 100,
        right: 10,
        color: const Color(0xFF2d2a31),
        borderRadius: 2,
        titleStyle: getStyle(color: Colors.white, size: 18),
        subtitleStyle: getStyle(color: Colors.white, size: 14),
      ),
    );
  }

  void _showProgressDialog() {
    _overlayEntry = OverlayEntry(
      builder: (ctx) {
        return ProgressIndicator(
          onCallClose: () {
            _overlayEntry?.remove();
            Provider.of<Progressprov>(context, listen: false).reset();
          },
        );
      },
    );
    XFrame.insert(_overlayEntry!);
  }

  Future<void> _startParticleTask(GenerateType type) async {
    /// 检测参数合法性
    final particleprov = Provider.of<Particleprov>(context, listen: false);
    final avc = particleprov.avc;
    if (!avc) {
      _alertAVCError();
      return;
    }

    /// 参数
    final image = await pickImage();
    final docDir = await getAndCreateColorifyDir();
    final args = GenParticleArguments.from(particleprov, image, type, docDir);

    /// 进度条
    _showProgressDialog();

    /// 生成线程
    final generator = ColorifyGenerator(
      type,
      args,
      onProgressUpdate: (v) {
        Provider.of<Progressprov>(context, listen: false).update(v);
      },
      onReceiveIdenticonData: (port, v) async {
        port.send(
          IsolateDataPack(
            type: IsolateDataPackType.identiconUint8List,
            data: await generateIdenticonPng(v),
          ),
        );
      },
      onReceiveSocketDelay: (v) {
        Provider.of<Socketprov>(context, listen: false).updateDelay(v);
      },
      onReceiveSocketCommands: (v) {
        Provider.of<Socketprov>(context, listen: false).startTask(v);
      },
    );
    generator.start();
  }

  Future<void> _startBlockTask(GenerateType type) async {
    /// 检测参数合法性
    final blockprov = Provider.of<Blockprov>(context, listen: false);
    final avc = blockprov.avc;
    if (!avc) {
      _alertAVCError();
      return;
    }

    /// 参数
    final image = await pickImage();
    final docDir = await getAndCreateColorifyDir();
    final args = GenBlockArguments.from(
      blockprov,
      type: type,
      image: image,
      outDir: docDir,
    );

    /// 进度条
    _showProgressDialog();

    /// 生成线程
    final generator = ColorifyGenerator(
      type,
      args,
      onProgressUpdate: (v) {
        Provider.of<Progressprov>(context, listen: false).update(v);
      },
      onReceiveIdenticonData: (port, v) async {
        port.send(
          IsolateDataPack(
            type: IsolateDataPackType.identiconUint8List,
            data: await generateIdenticonPng(v),
          ),
        );
      },
      onReceiveSocketDelay: (v) {
        Provider.of<Socketprov>(context, listen: false).updateDelay(v);
      },
      onReceiveSocketCommands: (v) {
        Provider.of<Socketprov>(context, listen: false).startTask(v);
      },
    );
    generator.start();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.w,
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          NewBottombarPageButton(
            index: 0,
            icon: Icons.bubble_chart_rounded,
            label: "Particle",
          ),
          SizedBox(width: 10),
          NewBottombarPageButton(
            index: 1,
            icon: Icons.filter_hdr_rounded,
            label: "Block",
          ),
          SizedBox(width: 10),
          NewBottombarGenerateButton(
            onTap: () {
              final page = Provider.of<Pageprov>(context, listen: false).page;
              if (page == 0) {
                _startParticleTask(GenerateType.file);
              } else {
                _startBlockTask(GenerateType.file);
              }
            },
          ),
          SizedBox(width: 5),
          NewBottombarWSButton(
            onRequestingParticleTask: () => _startParticleTask(GenerateType.socket),
            onRequestingBlockTask: () => _startBlockTask(GenerateType.socket),
          ),
        ],
      ),
    );
  }
}
