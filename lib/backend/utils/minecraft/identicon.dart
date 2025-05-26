import 'package:flutter/material.dart' hide ProgressIndicator;
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';
import 'dart:ui' as ui;

/// Generates UInt8List identicon data from uuid
Future<Uint8List> generateIdenticonPng(String uuid) async {
  const int isize = 1024;
  const double dsize = 1024;

  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder, Rect.fromPoints(Offset.zero, const Offset(dsize, dsize)));
  final paint = Paint()..color = const Color(0xFFFFFFFF);
  canvas.drawRect(const Rect.fromLTWH(0, 0, dsize, dsize), paint);

  final String svgString = Jdenticon.toSvg(uuid, size: isize);
  final PictureInfo pictureInfo = await vg.loadPicture(SvgStringLoader(svgString), null);
  final ui.Image image = await pictureInfo.picture.toImage(isize, isize);

  canvas.drawImage(image, Offset.zero, Paint());

  final ui.Image fimage = await recorder.endRecording().toImage(isize, isize);

  final ByteData? byteData = await fimage.toByteData(format: ui.ImageByteFormat.png);
  final Uint8List pngBytes = byteData!.buffer.asUint8List();
  return pngBytes;
}
