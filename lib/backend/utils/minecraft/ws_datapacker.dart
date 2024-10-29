sealed class DatapackUtilities {
  static String subscribe(String eventName, {String? uuid}) {
    uuid ??= '00000000-0000-0000-0000-000000000000';
    return '''
{
	"body": {
		"eventName": "$eventName"
	},
	"header": {
		"requestId": "$uuid",
		"messagePurpose": "subscribe",
		"version": 1,
		"messageType": "commandRequest"
	}
}
''';
  }

  static String unsubscribe(String eventName) {
    return '''
{
	"body": {
		"eventName": "$eventName"
	},
	"header": {
		"requestId": "00000000-0000-0000-0000-000000000000",
		"messagePurpose": "unsubscribe",
		"version": 1,
		"messageType": "commandRequest"
	}
}
''';
  }

  static String commandRequest(String command, {String? uuid}) {
    uuid ??= '00000000-0000-0000-0000-000000000000';
    return '''
{
	"body": {
		"commandLine": "$command",
		"version": 1
	},
	"header": {
		"requestId": "$uuid",
		"messagePurpose": "commandRequest",
		"version": 1,
		"messageType": "commandRequest"
	}
}
''';
  }
}
