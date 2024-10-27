import 'dart:isolate';

import 'package:colorify/backend/abstracts/isolate_data_pack.dart';

extension SendPortExt on SendPort {
  void sendData(IsolateDataPack datapack) {
    send(datapack);
  }
}
