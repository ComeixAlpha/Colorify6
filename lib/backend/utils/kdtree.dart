import 'dart:io';
import 'dart:math';

class PaletteEntry {
  String id;
  int r;
  int g;
  int b;

  PaletteEntry(this.r, this.g, this.b, this.id);

  List<int> toList() {
    return [r, g, b];
  }

  static PaletteEntry from(Map<String, Object> map) {
    return PaletteEntry(
      (map['rgb'] as List<int>)[0],
      (map['rgb'] as List<int>)[1],
      (map['rgb'] as List<int>)[2],
      map['id'] as String,
    );
  }

  @override
  String toString() => '$id ($r, $g, $b)';
}

class KDNode {
  PaletteEntry entry;
  KDNode? left;
  KDNode? right;

  KDNode(this.entry);
}

class KDTree {
  KDNode? root;
  List<int> axisOrder;

  KDTree(List<PaletteEntry> palette) : axisOrder = _findBestAxisOrder(palette) {
    root = _buildTree(palette, 0);
  }

  KDNode? _buildTree(List<PaletteEntry> palette, int depth) {
    if (palette.isEmpty) return null;

    int axis = axisOrder[depth % 3];
    palette.sort((a, b) => a.toList()[axis].compareTo(b.toList()[axis]));
    int medianIndex = palette.length ~/ 2;

    KDNode node = KDNode(palette[medianIndex]);
    node.left = _buildTree(palette.sublist(0, medianIndex), depth + 1);
    node.right = _buildTree(palette.sublist(medianIndex + 1), depth + 1);

    return node;
  }

  static List<int> _findBestAxisOrder(List<PaletteEntry> colors) {
    List<double> variances = List.generate(3, (i) => _variance(colors, i));
    List<int> axisOrder = [0, 1, 2];
    axisOrder.sort((a, b) => variances[b].compareTo(variances[a]));
    return axisOrder;
  }

  static double _variance(List<PaletteEntry> palette, int axis) {
    double mean = palette.map((c) => c.toList()[axis]).reduce((a, b) => a + b) / palette.length;
    double sumOfSquares = palette.map((c) => pow(c.toList()[axis] - mean, 2)).reduce((a, b) => a + b) as double;
    return sumOfSquares / palette.length;
  }

  PaletteEntry? findNearest(PaletteEntry target) {
    return _findNearest(root, target, 0, null)?.entry;
  }

  KDNode? _findNearest(KDNode? node, PaletteEntry target, int depth, KDNode? best) {
    if (node == null) return best;

    int axis = axisOrder[depth % 3];

    KDNode? nextBest;
    KDNode? nextBranch;

    if (best == null || _distance(target, node.entry) < _distance(target, best.entry)) {
      nextBest = node;
    } else {
      nextBest = best;
    }

    if (target.toList()[axis] < node.entry.toList()[axis]) {
      nextBranch = node.left;
      nextBest = _findNearest(node.left, target, depth + 1, nextBest);
    } else {
      nextBranch = node.right;
      nextBest = _findNearest(node.right, target, depth + 1, nextBest);
    }

    if (nextBranch == null || _distanceToPlane(target, node.entry, axis) < _distance(target, nextBest?.entry)) {
      if (target.toList()[axis] < node.entry.toList()[axis]) {
        nextBest = _findNearest(node.right, target, depth + 1, nextBest);
      } else {
        nextBest = _findNearest(node.left, target, depth + 1, nextBest);
      }
    }

    return nextBest;
  }

  int _distance(PaletteEntry? a, PaletteEntry? b) {
    if (a == null || b == null) {
      throw Exception('KDTree::_distance(): a or b is null');
    }
    return (a.r - b.r).abs() + (a.g - b.g).abs() + (a.b - b.b).abs();
  }

  double _distanceToPlane(PaletteEntry target, PaletteEntry point, int axis) {
    return (target.toList()[axis] - point.toList()[axis]).abs().toDouble();
  }

  /// Generates .dot file for tree structure visualization with Graphviz
  void generateDotFile(String fileName) {
    final buffer = StringBuffer();
    buffer.writeln('digraph G {');
    _generateDot(root, buffer);
    buffer.writeln('}');
    File(fileName).writeAsStringSync(buffer.toString());
  }

  void _generateDot(KDNode? node, StringBuffer buffer, [int depth = 0]) {
    if (node == null) return;
    final nodeId = node.hashCode;
    buffer.writeln('  $nodeId [label="${node.entry}"];');
    if (node.left != null) {
      final leftId = node.left.hashCode;
      buffer.writeln('  $nodeId -> $leftId [label="L"];');
      _generateDot(node.left, buffer, depth + 1);
    }
    if (node.right != null) {
      final rightId = node.right.hashCode;
      buffer.writeln('  $nodeId -> $rightId [label="R"];');
      _generateDot(node.right, buffer, depth + 1);
    }
  }
}
