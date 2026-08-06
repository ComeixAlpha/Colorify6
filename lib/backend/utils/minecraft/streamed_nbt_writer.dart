// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

class StreamedNbtWriter {
  final IOSink sink;
  final Endian endian = Endian.little;

  StreamedNbtWriter(this.sink);

  static const int TAG_END = 0;
  static const int TAG_INT = 3;
  static const int TAG_STRING = 8;
  static const int TAG_LIST = 9;
  static const int TAG_COMPOUND = 10;

  void writeCompoundHeader(String name) {
    sink.add([TAG_COMPOUND]);
    _writeStringData(name);
  }

  void writeCompoundEnd() {
    sink.add([TAG_END]);
  }

  void writeIntTag(String name, int value) {
    sink.add([TAG_INT]);
    _writeStringData(name);
    _writeInt32(value);
  }

  void writeStringTag(String name, String value) {
    sink.add([TAG_STRING]);
    _writeStringData(name);
    _writeStringData(value);
  }

  void writeListHeader(String name, int elementType, int length) {
    sink.add([TAG_LIST]);
    _writeStringData(name);
    sink.add([elementType]);
    _writeInt32(length);
  }

  void writeNamelessListHeader(int elementType, int length) {
    sink.add([elementType]);
    _writeInt32(length);
  }

  void writeNamelessInt(int value) {
    _writeInt32(value);
  }

  Future<void> writeMassiveIntList(
    Int32List data, {
    int initialChunkSize = 100000,
    void Function(int, int)? onProgress,
    int? progressOffset,
    int? totalElements,
  }) async {
    int offset = 0;
    int currentChunkSize = initialChunkSize;

    const int targetFrameTimeMs = 8;

    final stopwatch = Stopwatch();

    while (offset < data.length) {
      stopwatch.reset();
      stopwatch.start();

      int take = (data.length - offset > currentChunkSize)
          ? currentChunkSize
          : data.length - offset;

      final byteData = ByteData(take * 4);
      for (int i = 0; i < take; i++) {
        byteData.setInt32(i * 4, data[offset + i], endian);
      }

      sink.add(byteData.buffer.asUint8List());
      offset += take;

      if (onProgress != null && progressOffset != null && totalElements != null) {
        onProgress(progressOffset + offset, totalElements);
      }

      stopwatch.stop();
      final elapsed = stopwatch.elapsedMilliseconds;

      if (elapsed < targetFrameTimeMs / 2) {
        currentChunkSize = (currentChunkSize * 1.5).toInt();
      } else if (elapsed > targetFrameTimeMs * 2) {
        currentChunkSize = (currentChunkSize * 0.5).toInt();
        if (currentChunkSize < 10000) currentChunkSize = 10000;
      }

      await Future.delayed(Duration.zero);
    }
  }

  void _writeStringData(String value) {
    final bytes = utf8.encode(value);
    _writeUint16(bytes.length);
    sink.add(bytes);
  }

  void _writeUint16(int value) {
    final bd = ByteData(2)..setUint16(0, value, endian);
    sink.add(bd.buffer.asUint8List());
  }

  void _writeInt32(int value) {
    final bd = ByteData(4)..setInt32(0, value, endian);
    sink.add(bd.buffer.asUint8List());
  }
}
