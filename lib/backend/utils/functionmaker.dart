import 'dart:io';
import 'package:path/path.dart' as path;

class Functionmaker {
  Directory dir;

  StringBuffer _buffer = StringBuffer();
  int _lineCount = 0;
  int _fileCount = 0;
  Functionmaker({required this.dir});

  int get fileCount => _fileCount;

  Future<void> _writeLine(String line) async {
    _buffer.write('$line\n');
    _lineCount++;

    if (_lineCount >= 10000) {
      await end();
      _buffer = StringBuffer();
      _lineCount = 0;
      _fileCount++;
    }
  }

  Future<void> end() async {
    final savePath = path.join(dir.path, 'output_$_fileCount.mcfunction');
    final output = File(savePath);
    if (await output.exists()) {
      await output.delete();
      await output.writeAsString(_buffer.toString());
    } else {
      await output.writeAsString(_buffer.toString());
    }
  }

  Future<void> particle(num x, num y, num z, String pid) async {
    await _writeLine('particle $pid ~$x ~$y ~$z');
  }

  Future<void> command(String cstr) async {
    await _writeLine(cstr);
  }
}
