import 'dart:isolate';

import 'package:colorify/backend/abstracts/isolate_data_pack.dart';
import 'package:colorify/backend/extensions/on_string.dart';
import 'package:colorify/backend/generators/generator.dart';
import 'package:colorify/backend/generators/generator_block.dart';
import 'package:colorify/backend/generators/generator_particle.dart';
import 'package:colorify/backend/providers/block.prov.dart';
import 'package:colorify/backend/providers/page.prov.dart';
import 'package:colorify/backend/providers/particle.prov.dart';
import 'package:colorify/backend/providers/progress.prov.dart';
import 'package:colorify/backend/providers/socket.prov.dart';
import 'package:colorify/backend/utils/flie_picker.dart';
import 'package:colorify/backend/utils/identicon.dart';
import 'package:colorify/backend/utils/path.dart';
import 'package:colorify/frontend/components/bottombar/bottombar_button.dart';
import 'package:colorify/frontend/components/bottombar/bottombar_page_button.dart';
import 'package:colorify/frontend/components/bottombar/websocket_button.dart';
import 'package:colorify/frontend/components/processing/progress_indicator.dart';
import 'package:colorify/frontend/pages/block/block_arguments.dart';
import 'package:colorify/frontend/pages/particle/particle_arguments.dart';
import 'package:colorify/ui/basic/xframe.dart';
import 'package:colorify/ui/hide/message_dialog.dart';
import 'package:colorify/ui/util/text_style.dart';
import 'package:flutter/material.dart' hide ProgressIndicator;
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;
import 'package:provider/provider.dart';

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

  Future<void> _requestParticleTask(GenerateType type) async {
    final particleprov = Provider.of<Particleprov>(context, listen: false);
    final avc = particleprov.avc;
    if (!avc) {
      _alertAVCError();
      return;
    }

    img.Image? image = await pickImage();
    final docDir = await getAndCreateColorifyDir();

    final args = GenParticleArguments(
      image: image,
      samp: ptecSampling.text.toDouble(),
      heig: ptecHeight.text.toDouble(),
      rx: ptecrx.text.toDouble(),
      ry: ptecry.text.toDouble(),
      rz: ptecrz.text.toDouble(),
      pkName: ptecpkname.text,
      pkAuth: ptecpkauth.text,
      pkDesc: ptecpkdesc.text,
      plane: particleprov.plane,
      type: type,
      mode: particleprov.mode,
      outDir: docDir,
      mappings: particleprov.mappings,
    );
    await _startTask(type, pArgClosure(args));
    image = null;
  }

  Future<void> __requestBlockTask(GenerateType type) async {
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
            data: await processIdenticon(v),
          ),
        );
      },
      onReceiveSocketCommands: (v) {
        Provider.of<Socketprov>(context, listen: false).startTask(v);
      },
    );
    generator.start();
  }

  Future<void> _requestBlockTask(GenerateType type) async {
    final blockprov = Provider.of<Blockprov>(context, listen: false);
    final avc = blockprov.avc;
    if (!avc) {
      _alertAVCError();
      return;
    }
    final image = await pickImage();
    final docDir = await getAndCreateColorifyDir();
    final args = GenBlockArguments(
      type: type,
      image: image,
      outDir: docDir,
      palette: blockprov.filteredPalette,
      samp: btecSampling.text.toDouble(),
      pkName: btecpkname.text,
      pkAuth: btecpkauth.text,
      pkDesc: btecpkdesc.text,
      version: btecflattn.text,
      basicOffset: [
        btecbox.text.toInt(),
        btecboy.text.toInt(),
        btecboz.text.toInt(),
      ],
      plane: blockprov.plane,
      stairType: blockprov.stairType,
      useStruct: blockprov.useStruct,
      dithering: blockprov.dithering,
    );
    await _startTask(type, bArgClosure(args));
  }

  Future<void> _startTask(GenerateType type, void Function(SendPort) generator) async {
    if (type != GenerateType.socket) {
      _showProgressDialog();
    }

    ReceivePort receivePort = ReceivePort();
    await Isolate.spawn(generator, receivePort.sendPort);

    late final SendPort isolatePort;
    receivePort.listen(
      (message) async {
        if (message is double) {
          Provider.of<Progressprov>(context, listen: false).update(ProgressData(state: '', progress: message));
        } else if (message is SendPort) {
          isolatePort = message;
        } else if (message is String) {
          const int isize = 1024;
          const double dsize = 1024;

          final recorder = ui.PictureRecorder();
          final canvas = Canvas(recorder, Rect.fromPoints(Offset.zero, const Offset(dsize, dsize)));
          final paint = Paint()..color = const Color(0xFFFFFFFF);
          canvas.drawRect(const Rect.fromLTWH(0, 0, dsize, dsize), paint);

          final String svgString = Jdenticon.toSvg(message, size: isize);
          final PictureInfo pictureInfo = await vg.loadPicture(SvgStringLoader(svgString), null);
          final ui.Image image = await pictureInfo.picture.toImage(isize, isize);

          canvas.drawImage(image, Offset.zero, Paint());

          final ui.Image fimage = await recorder.endRecording().toImage(isize, isize);

          final ByteData? byteData = await fimage.toByteData(format: ui.ImageByteFormat.png);
          final Uint8List pngBytes = byteData!.buffer.asUint8List();
          isolatePort.send(pngBytes);
        } else if (message is List<String>) {
          Provider.of<Socketprov>(context, listen: false).startTask(message);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mqs = MediaQuery.of(context).size;
    final ow = mqs.width;
    const oh = 80.0; //mqs.height * 0.1;
    return SizedBox(
      width: ow,
      height: oh,
      child: Center(
        child: Container(
          width: ow - 26.0,
          height: 80.0,
          decoration: BoxDecoration(
            color: const Color(0xFF1d1a1f),
            borderRadius: BorderRadius.circular(35.0),
          ),
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BottombarPageButton(
                icon: Icons.bubble_chart_rounded,
                index: 0,
              ),
              const BottombarPageButton(
                icon: Icons.filter_hdr_rounded,
                index: 1,
              ),
              BottombarButton(
                color: const Color(0xFFb9acc9),
                iconColor: Colors.black,
                splashColor: const Color(0xFFeadaff),
                hoverColor: const Color(0xFFe7d3ff),
                icon: Icons.bolt_rounded,
                onTap: () {
                  final pageprov = Provider.of<Pageprov>(context, listen: false);
                  if (pageprov.page == 0) {
                    _requestParticleTask(GenerateType.file);
                  } else if (pageprov.page == 1) {
                    __requestBlockTask(GenerateType.file);
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
                            await _requestParticleTask(GenerateType.socket);
                          }
                        },
                      );
                    } else if (pageprov.page == 1) {
                      XFrame.comfirm(
                        '要通过WS传输像素画吗?',
                        (v) async {
                          if (v) {
                            await __requestBlockTask(GenerateType.socket);
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
