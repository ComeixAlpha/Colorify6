import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image/image.dart' as img;

Future<img.Image?> pick() async {
  final picked = await FilePicker.platform.pickFiles(type: FileType.image);
  if (picked == null) {
    return null;
  }
  final filePath = picked.files.single.path ?? '';
  final image = File(filePath);
  final bytes = await image.readAsBytes();
  final decodedImage = img.decodeImage(bytes);

  return decodedImage;
}
