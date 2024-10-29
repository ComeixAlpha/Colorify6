import 'dart:typed_data';
import 'package:dart_minecraft/dart_nbt.dart';
import 'package:vector_math/vector_math.dart';

// ignore: non_constant_identifier_names
final TEMPLATE = NbtCompound(name: '', children: [
  NbtInt(name: 'format_version', value: 1),
  NbtList<NbtInt>(
      name: "size",
      children: [NbtInt(name: "None", value: 2), NbtInt(name: "None", value: 2), NbtInt(name: "None", value: 2)]),
  NbtCompound(name: 'structure', children: [
    NbtList<NbtList>(name: "block_indices", children: [
      NbtList<NbtInt>(name: "None", children: [
        NbtInt(name: "None", value: -1),
        NbtInt(name: "None", value: -1),
        NbtInt(name: "None", value: -1),
        NbtInt(name: "None", value: -1),
        NbtInt(name: "None", value: -1),
        NbtInt(name: "None", value: -1),
        NbtInt(name: "None", value: -1),
        NbtInt(name: "None", value: 0),
      ]),
      NbtList<NbtInt>(name: "None", children: [
        NbtInt(name: "None", value: -1),
        NbtInt(name: "None", value: -1),
        NbtInt(name: "None", value: -1),
        NbtInt(name: "None", value: -1),
        NbtInt(name: "None", value: -1),
        NbtInt(name: "None", value: -1),
        NbtInt(name: "None", value: -1),
        NbtInt(name: "None", value: -1),
      ]),
    ]),
    NbtList<NbtCompound>(name: "entities", children: []),
    NbtCompound(name: "palette", children: [
      NbtCompound(
        name: "default",
        children: [
          NbtList<NbtCompound>(
            name: "block_palette",
            children: [
              NbtCompound(
                name: "None",
                children: [
                  NbtString(name: "name", value: "minecraft:concrete"),
                  NbtCompound<NbtTag>(name: "states", children: []),
                  NbtInt(name: "version", value: 18090528)
                ],
              )
            ],
          ),
          NbtCompound<NbtTag>(name: "block_position_data", children: []),
        ],
      ),
    ])
  ]),
  NbtList<NbtInt>(
      name: "structure_world_origin",
      children: [NbtInt(name: "None", value: 2), NbtInt(name: "None", value: 2), NbtInt(name: "None", value: 2)]),
]);

class Structure {
  late final Vector3 _size;
  final List<NbtInt> _blockIndices = [];
  final List<NbtInt> _blockIndicesInner = [];
  final List<String> _blockPaletteTypeId = [];
  final List<NbtCompound<NbtTag>> _blockPalette = [];

  Vector3 get size => _size;

  Structure(Vector3 size) {
    final Vector3 intifiedSize =
        Vector3(size.x.toInt().toDouble(), size.y.toInt().toDouble(), size.z.toInt().toDouble());
    _size = intifiedSize;
    _initBlockIndices(_size);
  }

  void _initBlockIndices(Vector3 size) {
    final int amount = (_size.x * _size.y * _size.z).toInt();
    for (int i = 0; i < amount; i++) {
      _blockIndices.add(NbtInt(name: "None", value: -1));
      _blockIndicesInner.add(NbtInt(name: "None", value: -1));
    }
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
        NbtInt(name: "version", value: 18090528)
      ],
    );
  }

  void setBlock(Vector3 pos, String typeId) {
    final bool conditionI = pos.x > _size.x || pos.y > _size.y || pos.z > _size.z;
    final bool conditionII = pos.x < 0 || pos.y < 0 || pos.z < 0;
    if (conditionI || conditionII) {
      // throw "Position out of range";
      return;
    }

    final Vector3 intifiedPos = Vector3(pos.x.toInt().toDouble(), pos.y.toInt().toDouble(), pos.z.toInt().toDouble());

    final int paletteIndex = _blockPaletteTypeId.indexOf(typeId);
    final int indicesIndex = _getIndexFromPos(intifiedPos);

    if (paletteIndex == -1) {
      _blockPaletteTypeId.add(typeId);
      _blockPalette.add(_getBlockPalette(typeId));
    }

    final int newPaletteIndex = _blockPaletteTypeId.indexOf(typeId);
    _blockIndices[indicesIndex] = NbtInt(name: "None", value: newPaletteIndex);
  }

  Future<void> writeFile(path) {
    final NbtCompound template = TEMPLATE;
    // ! Apply custom data
    template.children[0] = NbtInt(name: "format_version", value: 1);
    template.children[1] = NbtList<NbtInt>(name: "size", children: [
      NbtInt(name: "None", value: _size.x.toInt()),
      NbtInt(name: "None", value: _size.y.toInt()),
      NbtInt(name: "None", value: _size.z.toInt())
    ]);

    (template.children[2] as NbtList)[0] = NbtList<NbtList>(name: "block_indices", children: [
      NbtList<NbtInt>(name: "None", children: _blockIndices),
      NbtList<NbtInt>(name: "None", children: _blockIndicesInner),
    ]);

    (template.children[2] as NbtList)[1] = NbtList<NbtCompound>(name: "entities", children: []);

    (template.children[2] as NbtList)[2] = NbtCompound(name: "palette", children: [
      NbtCompound(
        name: "default",
        children: [
          NbtList<NbtCompound>(
            name: "block_palette",
            children: _blockPalette,
          ),
          NbtCompound<NbtTag>(name: "block_position_data", children: []),
        ],
      ),
    ]);

    final NbtWriter writer = NbtWriter(nbtCompression: NbtCompression.none);
    writer.setEndianness = Endian.little;
    return writer.writeFile(path, template);
  }
}
