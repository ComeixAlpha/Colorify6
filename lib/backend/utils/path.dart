import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

Future<Directory> pather() async {
  Directory dir;

  if (Platform.isAndroid) {
    dir = Directory('/storage/emulated/0/Download/colorify/');
  } else {
    dir = Directory(path.join((await getApplicationDocumentsDirectory()).path, 'colorify'));
  }

  /// Clear existing cache
  if (await dir.exists()) {
    await dir.delete(recursive: true);
  }
  await dir.create(recursive: true);

  return dir;
}
