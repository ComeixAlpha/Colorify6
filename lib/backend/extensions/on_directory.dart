import 'dart:io';
import 'package:path/path.dart' as path;

extension DirExt on Directory {
  Directory concact(String child) {
    return Directory(path.join(this.path, child));
  }

  Future<void> createIfNotExist() async {
    if (!await exists()) {
      create();
    }
  }
}