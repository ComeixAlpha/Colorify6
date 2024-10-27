import 'dart:math';

import 'package:colorify/backend/abstracts/block_with_state.dart';
import 'package:vector_math/vector_math.dart';

/// Block abstract
class Block {
  int x;
  int y;
  int z;
  BlockWithState block;
  Block({
    required this.x,
    required this.y,
    required this.z,
    required this.block,
  });
}

/// BlockMatrix class records blocks with its position
/// And also, automatically updates area size
class BlockMatrix {
  // Minimum x pos
  int _lx = 5431325;
  // Minimum y pos
  int _ly = 5431325;
  // Minimum z pos
  int _lz = 5431325;
  // Maximum x pos
  int _mx = -5431325;
  // Maximum y pos
  int _my = -5431325;
  // Maximum z pos
  int _mz = -5431325;
  late final List<Block> _blocks;
  BlockMatrix() {
    _blocks = [];
  }

  List<Block> get blocks => _blocks;
  int get lx => _lx;
  int get ly => _ly;
  int get lz => _lz;
  int get mx => _mx;
  int get my => _my;
  int get mz => _mz;

  Vector3 get size => Vector3(
        _mx - _lx + 1,
        _my - _ly + 1,
        _mz - _lz + 1,
      );

  void push(Block block) {
    _blocks.add(block);
    _lx = min(_lx, block.x);
    _mx = max(_mx, block.x);
    _ly = min(_ly, block.y);
    _my = max(_my, block.y);
    _lz = min(_lz, block.z);
    _mz = max(_mz, block.z);
  }
}