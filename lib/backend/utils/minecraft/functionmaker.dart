import 'dart:io';
import 'package:path/path.dart' as path;

/// Builder for Minecraft .mcfunction file with indices
/// 
/// Automatically split file when 10000 max lines limit reached.
class Functionmaker {
  /// Output directory
  Directory dir;

  /// Cache function string buffer
  ///
  /// Reset when a new function file was created.
  /// Write as string when a single file reached 10000 max lines limit or Functionmaker.end() is called.
  StringBuffer _buffer = StringBuffer();

  /// Records command lines amount in a single function file
  int _lineCount = 0;

  /// Record function file amount
  int _fileCount = 0;

  Functionmaker({required this.dir});

  int get fileCount => _fileCount;

  /// Write a command line to string buffer
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

  /// Mark as an end of once functions output
  /// 
  /// Write the rest commands to a new function file (the last one)
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

  /// Write a particle command line
  Future<void> particle(num x, num y, num z, String pid) async {
    await _writeLine('particle $pid ~$x ~$y ~$z');
  }

  /// Write a common command line
  Future<void> command(String cstr) async {
    await _writeLine(cstr);
  }
}
