import 'dart:convert';

sealed class DatapackUtilities {
  static const String _defaultUuid = '00000000-0000-0000-0000-000000000000';

  static String subscribe(String eventName, {String? uuid}) {
    return jsonEncode({
      'body': {
        'eventName': eventName,
      },
      'header': {
        'requestId': uuid ?? _defaultUuid,
        'messagePurpose': 'subscribe',
        'version': 1,
        'messageType': 'commandRequest',
      },
    });
  }

  static String unsubscribe(String eventName, {String? uuid}) {
    return jsonEncode({
      'body': {
        'eventName': eventName,
      },
      'header': {
        'requestId': uuid ?? _defaultUuid,
        'messagePurpose': 'unsubscribe',
        'version': 1,
        'messageType': 'commandRequest',
      },
    });
  }

  static String commandRequest(String command, {String? uuid}) {
    return jsonEncode({
      'body': {
        'commandLine': command,
        'version': 1,
      },
      'header': {
        'requestId': uuid ?? _defaultUuid,
        'messagePurpose': 'commandRequest',
        'version': 1,
        'messageType': 'commandRequest',
      },
    });
  }
}
