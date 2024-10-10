import 'dart:isolate';

import 'package:colorify/backend/extensions/on_string.dart';
import 'package:colorify/backend/generators/generator_block.dart';
import 'package:colorify/backend/generators/generator_particle.dart';
import 'package:colorify/backend/providers/block.prov.dart';
import 'package:colorify/backend/providers/page.prov.dart';
import 'package:colorify/backend/providers/particle.prov.dart';
import 'package:colorify/backend/providers/progress.prov.dart';
import 'package:colorify/backend/providers/socket.prov.dart';
import 'package:colorify/backend/utils/flie_picker.dart';
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

  Future<void> _requestParticleTask(GenerateType type) async {
    final particleprov = Provider.of<Particleprov>(context, listen: false);
    final avc = particleprov.avc;
    if (!avc) {
      XFrame.message(
        'AVC ERROR',
        subtitle: 'Avc failed',
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
      return;
    }
    final image = await pick();
    final docDir = await pather();
    final args = GParticleArguments(
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
  }

  Future<void> _requestBlockTask(GenerateType type) async {
    final blockprov = Provider.of<Blockprov>(context, listen: false);
    final avc = blockprov.avc;
    if (!avc) {
      XFrame.message(
        'AVC ERROR',
        subtitle: 'Avc failed',
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
      return;
    }
    final image = await pick();
    final docDir = await pather();
    final args = GBlockArguments(
      type: type,
      image: image,
      outDir: docDir,
      palette: blockprov.palette,
      samp: btecSampling.text.toDouble(),
      pkName: btecpkname.text,
      pkAuth: btecpkauth.text,
      pkDesc: btecpkdesc.text,
      plane: blockprov.plane,
      stairType: blockprov.stairType,
      useStruct: blockprov.useStruct,
      dithering: blockprov.dithering,
    );
    await _startTask(type, bArgClosure(args));
  }

  Future<void> _startTask(GenerateType type, void Function(SendPort) generator) async {
    if (type != GenerateType.socket) {
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

    ReceivePort receivePort = ReceivePort();
    await Isolate.spawn(generator, receivePort.sendPort);

    late final SendPort isolatePort;
    receivePort.listen(
      (message) async {
        if (message is double) {
          Provider.of<Progressprov>(context, listen: false).update(message);
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
    final oh = mqs.height * 0.1;
    return SizedBox(
      width: ow,
      height: oh,
      child: Center(
        child: Container(
          width: ow - 40.0,
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
                icon: Icons.bubble_chart,
                index: 0,
              ),
              const BottombarPageButton(
                icon: Icons.filter_hdr,
                index: 1,
              ),
              BottombarButton(
                color: const Color(0xFFb9acc9),
                iconColor: Colors.black,
                splashColor: const Color(0xFFeadaff),
                hoverColor: const Color(0xFFe7d3ff),
                icon: Icons.bolt,
                onTap: () {
                  final pageprov = Provider.of<Pageprov>(context, listen: false);
                  if (pageprov.page == 0) {
                    _requestParticleTask(GenerateType.file);
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
                        'Start Generate Particle?',
                        (v) async {
                          if (v) {
                            await _requestParticleTask(GenerateType.socket);
                          }
                        },
                      );
                    } else if (pageprov.page == 1) {
                      XFrame.comfirm(
                        'Start Generate Block Painting?',
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
