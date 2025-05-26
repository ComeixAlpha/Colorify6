import 'package:colorify/backend/abstracts/block_with_state.dart';
import 'package:colorify/backend/abstracts/flatten_history.dart';
import 'package:colorify/backend/assets/palette/palette.flatten.histories.dart';

/// Minecraft Bedrock Edition Flattening Manager
class FlattenManager {
  /// User's game version
  /// 
  /// This property represents the game version as a list of integers.
  /// CHS: Change Histories
  /// 
  /// This property stores a list of `ChangeHistory` objects, which represent the changes 
  /// in block IDs and their associated states between different Minecraft game versions.
  /// Each `ChangeHistory` contains:
  /// - `flattened`: The original block ID before the change.
  /// - `statemap`: A map where the key is the new block ID and the value is its state string.
  /// 
  /// The `chs` list is populated based on the user's game version, recording all changes 
  /// from the original block IDs to the current version's block IDs and states.
  List<ChangeHistory> chs = [];
  late final List<int> version;
  FlattenManager.version(String versionStr) {
    // Default version
    if (versionStr.isEmpty) {
      versionStr = '1.20.80';
    }

    // Version string rule
    if (!RegExp(r'\d+\.\d+(\.\d+)?').hasMatch(versionStr)) {
      throw FormatException('Invalid version string format: $versionStr. Expected format is "x.y" or "x.y.z" where x, y, and z are integers.');
    }

    version = versionStr.split('.').map((e) => int.parse(e)).toList();

    // Init chs
    for (FlattenHistory flattenHistory in flattenHistories) {
      if (isLaterVersion(flattenHistory.version)) {
        chs.addAll(flattenHistory.histories);
      }
    }
  }

  /// Compares two version
  bool isLaterVersion(List<int> v) {
    if (version.length == 2) {
      version.add(0);
    }
    if (v[0] >= version[0] && v[1] >= version[1] && v[2] >= version[2]) {
      return true;
    } else {
      return false;
    }
  }

  BlockWithState getBlockWithStateOf(String id) {
    for (ChangeHistory changeHistory in chs) {
      if (changeHistory.flattened == id) {
        final map = changeHistory.statemap;
        final pid = map.keys.toList()[0];
        final state = map[pid];
        return BlockWithState(id: pid, stateString: state);
      }
    }
    return BlockWithState(id: id);
  }
}
