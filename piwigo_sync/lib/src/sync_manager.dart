import 'dart:io';

import 'package:meta/meta.dart';

import 'connector.dart';

class SyncManager {
  final String host;
  final int port;
  final String username;
  final String password;
  final Duration interval;

  const SyncManager({
    @required this.host,
    @required this.port,
    @required this.username,
    @required this.password,
    @required this.interval,
  });

  Future<void> call() async {
    while (true) {
      await Future.delayed(interval);
      await _sync();
    }
  }

  Future<void> _sync() async {
    final client = await PiwigoConnector.connect(
      host,
      port,
    );
    try {
      await client.login(username, password);
      final result = await client.sync(
        simulate: true,
        displayInfo: true,
        syncMode: SyncMode.files,
      );
      for (final line in result) {
        stdout.writeln(line);
      }
    } catch (e) {
      stderr.writeln("Sync failed with exception: $e");
    } finally {
      client.dispose();
    }
  }
}
