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