import 'package:colorify/main.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  pref = await SharedPreferences.getInstance();

  if (pref!.getBool('ensure_permissions') ?? false) {
    return true;
  }

  final mes = await _requestPermission(Permission.manageExternalStorage);
  final sto = await _requestPermission(Permission.storage);
  final pho = await _requestPermission(Permission.photos);

  if (mes || sto) {
    return true;
  }

  return pho;
}
