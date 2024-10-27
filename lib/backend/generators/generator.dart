import 'dart:isolate';

import 'package:colorify/backend/abstracts/isolate_data_pack.dart';
import 'package:colorify/backend/generators/_generator_block.dart';
import 'package:colorify/backend/generators/generator_particle.dart';
import 'package:colorify/frontend/components/processing/progress_indicator.dart';
import 'package:colorify/frontend/scaffold/bottombar.dart';

class ColorifyGenerator<T> {
  GenerateType type;
  T arguments;
  SendPort? _sendPort;

  dynamic Function(ProgressData) onProgressUpdate;
  dynamic Function(SendPort, String) onReceiveIdenticonData;
  dynamic Function(List<String>) onReceiveSocketCommands;

  ColorifyGenerator(
    this.type,
    this.arguments, {
    required this.onProgressUpdate,
    required this.onReceiveIdenticonData,
    required this.onReceiveSocketCommands,
  });

  Future<void> start() async {
    ReceivePort receivePort = ReceivePort();

    void Function(SendPort) receiver;
    if (arguments is GenParticleArguments) {
      receiver = blockArgumentsReceiver;
    } else {
      receiver = blockArgumentsReceiver;
    }

    await Isolate.spawn(receiver, receivePort.sendPort);

    receivePort.listen(
      (recv) async {
        IsolateDataPack datapack = recv as IsolateDataPack;

        if (datapack.type == IsolateDataPackType.progressUpdate) {
          onProgressUpdate(datapack.data);
        } else if (datapack.type == IsolateDataPackType.sendPort) {
          _sendPort = datapack.data;
          _sendPort!.send(
            IsolateDataPack(type: IsolateDataPackType.blockArguments, data: arguments),
          );
        } else if (datapack.type == IsolateDataPackType.identiconData) {
          onReceiveIdenticonData(_sendPort!, datapack.data);
        } else if (datapack.type == IsolateDataPackType.socketCommands) {
          onReceiveSocketCommands(datapack.data);
        } else {
          throw Exception('Unexpected isolate data type');
        }
      },
    );
  }
}