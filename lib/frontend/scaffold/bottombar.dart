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
import 'package:colorify/frontend/components/bottombar/generate_button.dart';
import 'package:colorify/frontend/components/bottombar/page_button.dart';
import 'package:colorify/frontend/components/bottombar/websocket_button.dart';
import 'package:colorify/frontend/components/processing/progress_indicator.dart';
import 'package:colorify/ui/basic/xframe.dart';
import 'package:colorify/ui/hide/message_dialog.dart';
import 'package:colorify/ui/util/text_style.dart';
import 'package:flutter/material.dart' hide ProgressIndicator;
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

enum GenerateType {
  file,
  socket,
}

class Bottombar extends StatefulWidget {
  const Bottombar({super.key});

  @override
  State<Bottombar> createState() => _BottombarState();
}

class _BottombarState extends State<Bottombar> {
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
        return ProgressIndicator(onCallClose: () {
          _overlayEntry?.remove();
          Provider.of<Progressprov>(context, listen: false).reset();
        });
      },
    );
    XFrame.insert(_overlayEntry!);
  }

  Future<void> __requestParticleTask(GenerateType type) async {
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
    final args = GenParticleArguments.from(
      particleprov,
      image,
      type,
      docDir,
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

  Future<void> _requestBlockTask(GenerateType type) async {
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
    final ow = 100.w;
    const oh = 80.0;
    return SizedBox(
      width: ow,
      height: oh,
      child: Center(
        child: Container(
          width: ow - 26.0,
          height: 80.0,
          decoration: BoxDecoration(
            color: const Color(0xFF1d1a1f),
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(153),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const PageButton(
                index: 0,
                icon: Icons.bubble_chart_rounded,
              ),
              const PageButton(
                index: 1,
                icon: Icons.filter_hdr_rounded,
              ),
              GenerateButton(
                onTap: () {
                  final pageprov = Provider.of<Pageprov>(context, listen: false);
                  if (pageprov.page == 0) {
                    __requestParticleTask(GenerateType.file);
                  } else if (pageprov.page == 1) {
                    _requestBlockTask(GenerateType.file);
                  } else {}
                },
              ),
              WebsocketButton(
                onTap: () async {
                  final pageprov = Provider.of<Pageprov>(context, listen: false);
                  final socketprov = Provider.of<Socketprov>(context, listen: false);
                  if (socketprov.connected) {
                    if (pageprov.page == 0) {
                      XFrame.comfirm(
                        '要通过WS传输粒子画吗?',
                        (v) async {
                          if (v) {
                            await __requestParticleTask(GenerateType.socket);
                          }
                        },
                      );
                    } else if (pageprov.page == 1) {
                      XFrame.comfirm(
                        '要通过WS传输像素画吗?',
                        (v) async {
                          if (v) {
                            await _requestBlockTask(GenerateType.socket);
                          }
                        },
                      );
                    }
                  }
                  pageprov.update(2);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
