import 'dart:async';
import 'dart:io';

import 'package:colorify/backend/extensions/on_directory.dart';
import 'package:path_provider/path_provider.dart';

Future<Directory> getColorifyDir() async {
  if (Platform.isAndroid) {
    return Directory('/storage/emulated/0/Download/colorify/');
  } else {
    return (await getApplicationDocumentsDirectory()).concact('colorify');
  }
}

Future<Directory> getAndCreateColorifyDir() async {
  Directory dir;

  if (Platform.isAndroid) {
    dir = Directory('/storage/emulated/0/Download/colorify/');
  } else {
    dir = (await getApplicationDocumentsDirectory()).concact('colorify');
  }

  /// Clear existing cache
  if (await dir.exists()) {
    await forceDeleteDirectory(dir.path);
  }

  await dir.create(recursive: true);

  return dir;
}

Future<void> forceDeleteDirectory(String path) async {
  final dir = Directory(path);
  if (!await dir.exists()) {
    return;
  }

  if (Platform.isWindows) {
    final result = await Process.run('attrib', ['-R', '-S', '-H', path, '/S', '/D']);
    if (result.exitCode != 0) {
      return;
    }
  }

  try {
    await dir.delete(recursive: true);
  } on FileSystemException catch (_) {
    return;
  }
}
