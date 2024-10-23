import 'package:colorify/backend/abstracts/flatten_history.dart';
import 'package:colorify/backend/palette/palette.flatten.histories.dart';

class BlockWithState {
  String id;
  String? stateString;
  BlockWithState({
    required this.id,
    this.stateString,
  });

  String get state {
    return stateString ?? '';
  }
}

class FlattenManager {
  late final List<int> version;
  List<ChangeHistory> chs = [];
  FlattenManager.version(String versionStr) {
    if (versionStr.isEmpty) {
      versionStr = '1.20.80';
    }
    if (!RegExp(r'\d+\.\d+(\.\d+)?').hasMatch(versionStr)) {
      throw Exception();
    }

    version = versionStr.split('.').map((e) => int.parse(e)).toList();

    for (FlattenHistory flattenHistory in flattenHistories) {
      if (isLaterVersion(flattenHistory.version)) {
        chs.addAll(flattenHistory.histories);
      }
    }
  }

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
