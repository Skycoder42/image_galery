import 'dart:io';

import 'package:piwigo_sync/config.dart';
import 'package:piwigo_sync/src/connector.dart';

Future<void> main(List<String> arguments) async {
  final client = await PiwigoConnector.connect("localhost");
  try {
    await client.login(piwigoUserName, piwigoPassword);
    final result = await client.sync(
      simulate: true,
      displayInfo: true,
      syncMode: SyncMode.files,
    );
    for (final line in result) {
      stdout.writeln(line);
    }
  } finally {
    client.dispose();
  }
}
