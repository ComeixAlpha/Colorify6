class ChangeHistory {
  Map<String, String> statemap;
  String flattened;

  ChangeHistory({
    required this.statemap,
    required this.flattened,
  });
}

class FlattenHistory {
  List<int> version;
  List<ChangeHistory> histories;

  FlattenHistory({
    required this.version,
    required this.histories,
  });
}
