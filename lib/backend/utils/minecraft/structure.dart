import 'dart:io';
import 'dart:typed_data';

import 'package:colorify/backend/utils/minecraft/streamed_nbt_writer.dart';
import 'package:dart_minecraft/dart_nbt.dart';
import 'package:vector_math/vector_math.dart';

class Structure {
  late final Vector3 _size;
  late final Int32List _blockIndices;
  late final Int32List _blockIndicesInner;
  final List<String> _blockPaletteTypeId = [];
  final List<NbtCompound<NbtTag>> _blockPalette = [];

  Vector3 get size => _size;

  Structure(Vector3 size) {
    final Vector3 intifiedSize = Vector3(
      size.x.toInt().toDouble(),
      size.y.toInt().toDouble(),
      size.z.toInt().toDouble(),
    );
    _size = intifiedSize;
    _initBlockIndices(_size);
  }

  void _initBlockIndices(Vector3 size) {
    final int amount = (_size.x * _size.y * _size.z).toInt();

    _blockIndices = Int32List(amount);
    _blockIndicesInner = Int32List(amount);

    _blockIndices.fillRange(0, amount, -1);
    _blockIndicesInner.fillRange(0, amount, -1);
  }

  int _getIndexFromPos(Vector3 pos) {
    final double x = pos.x;
    final double y = pos.y;
    final double z = pos.z;
    double amount = 0;
    if (x > 0) {
      amount += (x - 1) * _size.y * _size.z;
    }
    if (y > 0) {
      amount += (y - 1) * _size.z;
    }
    if (z > 0) {
      amount += (z - 1);
    }
    return amount.toInt();
  }

  NbtCompound _getBlockPalette(String typeId) {
    return NbtCompound(
      name: "None",
      children: [
        NbtString(name: "name", value: typeId),
        NbtCompound<NbtTag>(name: "states", children: []),
        NbtInt(name: "version", value: 18090528),
      ],
    );
  }

  void setBlock(Vector3 pos, String typeId) {
    final bool conditionI = pos.x > _size.x || pos.y > _size.y || pos.z > _size.z;
    final bool conditionII = pos.x < 0 || pos.y < 0 || pos.z < 0;
    if (conditionI || conditionII) {
      return;
    }

    final Vector3 intifiedPos = Vector3(
      pos.x.toInt().toDouble(),
      pos.y.toInt().toDouble(),
      pos.z.toInt().toDouble(),
    );

    final int paletteIndex = _blockPaletteTypeId.indexOf(typeId);
    final int indicesIndex = _getIndexFromPos(intifiedPos);

    if (paletteIndex == -1) {
      _blockPaletteTypeId.add(typeId);
      _blockPalette.add(_getBlockPalette(typeId));
    }

    final int newPaletteIndex = _blockPaletteTypeId.indexOf(typeId);

    _blockIndices[indicesIndex] = newPaletteIndex;
  }

  Future<void> writeFile(String path, {void Function(int, int)? onProgress}) async {
    final file = File(path);
    final sink = file.openWrite();
    final writer = StreamedNbtWriter(sink);

    final int totalBlocks = _blockIndices.length + _blockIndicesInner.length;

    // Root
    writer.writeCompoundHeader("");

    writer.writeIntTag("format_version", 1);

    writer.writeListHeader("size", StreamedNbtWriter.TAG_INT, 3);
    writer.writeNamelessInt(_size.x.toInt());
    writer.writeNamelessInt(_size.y.toInt());
    writer.writeNamelessInt(_size.z.toInt());

    writer.writeCompoundHeader("structure");

    writer.writeListHeader("block_indices", StreamedNbtWriter.TAG_LIST, 2);

    writer.writeNamelessListHeader(StreamedNbtWriter.TAG_INT, _blockIndices.length);
    await writer.writeMassiveIntList(
      _blockIndices,
      onProgress: onProgress,
      progressOffset: 0,
      totalElements: totalBlocks,
    );

    writer.writeNamelessListHeader(StreamedNbtWriter.TAG_INT, _blockIndicesInner.length);
    await writer.writeMassiveIntList(
      _blockIndicesInner,
      onProgress: onProgress,
      progressOffset: _blockIndices.length,
      totalElements: totalBlocks,
    );

    // Empty entities list
    writer.writeListHeader("entities", StreamedNbtWriter.TAG_END, 0);

    writer.writeCompoundHeader("palette");
    writer.writeCompoundHeader("default");

    writer.writeListHeader(
      "block_palette",
      StreamedNbtWriter.TAG_COMPOUND,
      _blockPaletteTypeId.length,
    );
    for (var typeId in _blockPaletteTypeId) {
      writer.writeStringTag("name", typeId);
      writer.writeCompoundHeader("states");
      writer.writeCompoundEnd();
      writer.writeIntTag("version", 18090528);
      writer.writeCompoundEnd();
    }

    writer.writeCompoundHeader("block_position_data");
    writer.writeCompoundEnd();

    writer.writeCompoundEnd();
    writer.writeCompoundEnd();

    writer.writeCompoundEnd();

    writer.writeListHeader("structure_world_origin", StreamedNbtWriter.TAG_INT, 3);
    writer.writeNamelessInt(2);
    writer.writeNamelessInt(2);
    writer.writeNamelessInt(2);

    writer.writeCompoundEnd();

    await sink.flush();
    await sink.close();
  }
}
