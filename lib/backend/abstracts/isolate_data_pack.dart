enum IsolateDataPackType {
  particleArguments,
  blockArguments,
  progressUpdate,
  sendPort,
  identiconData,
  identiconUint8List,
  socketCommands,
}

class IsolateDataPack {
  IsolateDataPackType type;
  dynamic data;

  IsolateDataPack({
    required this.type,
    required this.data,
  });
}
