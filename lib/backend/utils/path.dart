import 'dart:async';
import 'dart:io';

import 'package:colorify/backend/extensions/on_directory.dart';
import 'package:path_provider/path_provider.dart';

Future<Directory> getAndCreateColorifyDir() async {
  Directory dir;

  if (Platform.isAndroid) {
    dir = Directory('/storage/emulated/0/Download/colorify/');
  } else {
    dir = (await getApplicationDocumentsDirectory()).concact('colorify');
  }

  /// Clear existing cache
  if (await dir.exists()) {
    await dir.delete(recursive: true);
  }

  await dir.create(recursive: true);

  return dir;
}
