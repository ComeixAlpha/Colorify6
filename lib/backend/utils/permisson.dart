import 'package:permission_handler/permission_handler.dart';

Future<bool> _requestPermission(
  Permission permission,
) async {
  final isGranted = await permission.isGranted;

  if (!isGranted) {
    final status = await permission.request();

    if (status.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  return true;
}

Future<bool> requestStorage() async {
  final mes = await _requestPermission(Permission.manageExternalStorage);
  final sto = await _requestPermission(Permission.storage);
  final pho = await _requestPermission(Permission.photos);

  return mes && sto && pho;
}
